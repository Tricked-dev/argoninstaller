// THIS CODE IS LICENSED UNDER GPL-3
// PORT OF https://github.com/ResetPower/Epherome/blob/main/src/core/auth.ts license: GPL-3

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:simple_auth/simple_auth.dart' as simpleAuth;
import '../../config.dart';

enum Reason {
  //"The account is not satisfied with this action"
  satisfied
}

class MSAuthError extends Error {
  final Reason reason;
  MSAuthError(this.reason);
}

class TAzure extends simpleAuth.AzureADApi implements showAuthenticator {
  TAzure(String identifier, String clientId, String tokenUrl, String resource,
      String authorizationUrl, String redirectUrl)
      : super(identifier, clientId, tokenUrl, resource, authorizationUrl,
            redirectUrl);
}

class MSAuth {
  static const MICROSOFT_CLIENT_ID = "e2d21d17-35c3-46e6-9afd-f475b0f08c46";
  static const AZURE_TENNANT = "f8cdef31-a31e-4b4a-93e4-5f571e91255a";
  static final simpleAuth.AzureADApi azureApi = simpleAuth.AzureADApi(
      "azure",
      MICROSOFT_CLIENT_ID,
      "https://login.microsoftonline.com/$AZURE_TENNANT/oauth2/authorize",
      "https://login.microsoftonline.com/$AZURE_TENNANT/oauth2/token",
      "https://management.azure.com/",
      "redirecturl");

  static Future<Map> authCode2AuthToken(String code) async {
    var map = <String, dynamic>{};
    map["code"] = code;
    map["client_id"] = MICROSOFT_CLIENT_ID;
    map["grant_type"] = "authorization_code";
    map["redirect_uri"] = "https://login.live.com/oauth20_desktop.srf";
    map["scope"] = "service::user.auth.xboxlive.com::MBI_SSL";

    try {
      var r = await http.post(
          Uri.parse("https://login.live.com/oauth20_token.srf"),
          headers: {"Content-Type": "application/x-www-form-urlencoded"},
          body: map);

      return json.decode(r.body);
    } catch (e) {
      return {"err": true};
    }
  }

  static Future<Map> authToken2XBLToken(String token) async {
    var map = <String, dynamic>{
      "Properties": {
        "AuthMethod": "RPS",
        "SiteName": "user.auth.xboxlive.com",
        "RpsTicket": token,
      },
      "RelyingParty": "http://auth.xboxlive.com",
      "TokenType": "JWT",
    };

    try {
      var r = await http.post(
          Uri.parse("https://user.auth.xboxlive.com/user/authenticate"),
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json",
          },
          body: map);

      return json.decode(r.body);
    } catch (e) {
      return {"err": true};
    }
  }

  static Future<Map> XBLToken2XSTSToken(String token) async {
    var map = <String, dynamic>{
      "Properties": {
        "SandboxId": "RETAIL",
        "UserTokens": [token],
      },
      "RelyingParty": "rp://api.minecraftservices.com/",
      "TokenType": "JWT",
    };

    try {
      var r = await http.post(
          Uri.parse("https://xsts.auth.xboxlive.com/xsts/authorize"),
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json",
          },
          body: map);

      return json.decode(r.body);
    } catch (e) {
      return {"err": true};
    }
  }

  static XSTSToken2MinecraftToken(String token, String uhs) async {
    var map = <String, dynamic>{
      "identityToken": "XBL3.0 x=${uhs};${token}",
    };

    try {
      var r = await http.post(
          Uri.parse(
              "https://api.minecraftservices.com/authentication/login_with_xbox"),
          headers: {
            "Content-Type": "application/json",
          },
          body: map);

      return json.decode(r.body);
    } catch (e) {
      return {"err": true};
    }
  }

  static checkMinecraftOwnership(String token) async {
    try {
      var r = await http.get(
        Uri.parse("https://api.minecraftservices.com/entitlements/mcstore"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${token}",
        },
      );

      return json.decode(r.body);
    } catch (e) {
      return {"err": true};
    }
  }

  static getMicrosoftMinecraftProfile(String token) async {
    try {
      var r = await http.get(
        Uri.parse("https://api.minecraftservices.com/minecraft/profile"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${token}",
        },
      );

      return json.decode(r.body);
    } catch (e) {
      return {"err": true};
    }
  }

  static bool validateMicrosoft(String token) {
    final payload = utf8.decode(base64.decode(token.split(".")[0]));
    final params = json.decode(payload);
    return (DateTime.now().millisecondsSinceEpoch / 1000).floor() <
        params["exp"];
  }

  static Future<bool> refreshMicrosoft(Map<String, dynamic> account) async {
    try {
      if (!account["refreshToken"] || account["mode"] != "microsoft") {
        throw MSAuthError(Reason.satisfied);
      }
      var r = await http.post(
          Uri.parse("https://user.auth.xboxlive.com/user/authenticate"),
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json",
          },
          body: {
            "client_id": MICROSOFT_CLIENT_ID,
            "refresh_token": account["refreshToken"],
            "grant_type": "refresh_token",
            "redirect_uri": "https://login.live.com/oauth20_desktop.srf",
          });
      var params = json.decode(r.body);
      var mcTokenResult =
          await authToken2MinecraftTokenDirectly(params["access_token"]);
      var mcToken = mcTokenResult["token"];
      if (mcTokenResult["err"] || !mcToken) {
        return false;
      }
      // updateAccountToken(account, mcToken, params["refresh_token"]);
      Config.preferences?.setString("account", json.encode(account));
      Config.preferences?.setString("mcToken", json.encode(mcToken));
      Config.preferences?.setString("refresh_token", params["refresh_token"]);
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<Map> authToken2MinecraftTokenDirectly(String authToken) async {
    var unsuccessfulWith = (String msg) {
      return {
        "err": msg,
      };
    };
    // Authorization Token -> XBL Token
    var XBLTokenResult = await authToken2XBLToken(authToken);
    var XBLToken = XBLTokenResult["Token"];
    if (XBLTokenResult["error"] || !XBLToken) {
      // unable to get xbl token
      return unsuccessfulWith(
          "Unable to get XBL token at microsoft authenticating");
    }

    // XBL Token -> XSTS Token
    var XSTSTokenResult = await XBLToken2XSTSToken(XBLToken);
    var XSTSToken = XSTSTokenResult["Token"];
    var XSTSTokenUhs = XSTSTokenResult["DisplayClaims"]?["xui"][0]["uhs"];
    if (XSTSTokenResult["error"] || !XSTSToken || !XSTSTokenUhs) {
      // unable to get xsts token
      return unsuccessfulWith(
          "Unable to XSTS auth token at microsoft authenticating");
    }

    // XSTS Token -> Minecraft Token
    var minecraftTokenResult =
        await XSTSToken2MinecraftToken(XSTSToken, XSTSTokenUhs);
    var minecraftToken = minecraftTokenResult.access_token;
    if (minecraftTokenResult.error || !minecraftToken) {
      // unable to get minecraft token
      return unsuccessfulWith("Unable to get Minecraft token");
    }

    return {"token": minecraftToken};
  }
}

package io.ionic.demo.ecommerce.plugins;

import com.getcapacitor.JSObject;
import com.getcapacitor.Plugin;
import com.getcapacitor.PluginCall;
import com.getcapacitor.PluginMethod;
import com.getcapacitor.annotation.CapacitorPlugin;
import com.google.gson.Gson;

import org.json.JSONException;
import org.json.JSONObject;

import io.ionic.demo.ecommerce.EcommerceApp;
import io.ionic.demo.ecommerce.data.DataService;
import io.ionic.demo.ecommerce.data.ShoppingCart;
import io.ionic.demo.ecommerce.data.model.Cart;
import io.ionic.demo.ecommerce.data.model.User;

@CapacitorPlugin(name = "ShopAPIPlugin")
public class ShopAPIPlugin extends Plugin {

    DataService dataService;

    ShopAPIPlugin() {
        dataService = DataService.getInstance();
    }

    @PluginMethod
    public void getCart(PluginCall call) {
        try {
            Cart cart = EcommerceApp.getInstance().getShoppingCart().getCart();
            String cartJson = new Gson().toJson(cart);
            JSObject cartJSObject = JSObject.fromJSONObject(new JSONObject(cartJson));
            call.resolve(cartJSObject);
        } catch (JSONException e) {
            call.reject("error decoding cart object");
        }
    }

    @PluginMethod
    public void getUserDetails(PluginCall call) {
        try {
            User user = dataService.getUser();
            String userJson = new Gson().toJson(user);
            JSObject userJSObject = JSObject.fromJSONObject(new JSONObject(userJson));
            call.resolve(userJSObject);
        } catch (JSONException e) {
            call.reject("error decoding user object");
        }
    }

    @PluginMethod
    public void updateUserDetails(PluginCall call) {
        JSObject userJSObject = call.getData();
        User user = new Gson().fromJson(userJSObject.toString(), User.class);
        dataService.setUser(user);
    }

    @PluginMethod
    public void checkoutResult(PluginCall call) {
        String result = call.getString("result");
        ShoppingCart cart = EcommerceApp.getInstance().getShoppingCart();
        cart.checkout(result);
    }

    @PluginMethod
    public void getUserPicture(PluginCall call) {
        User user = dataService.getUser();
        if (user.image != null && !user.image.isEmpty()) {
            String picture = user.getImageBase64(getContext());
            if (picture != null) {
                JSObject returnPicture = new JSObject();
                returnPicture.put("picture", picture);
                call.resolve(returnPicture);
                return;
            }
        }

        call.reject("No picture available");
    }

    @PluginMethod
    public void setUserPicture(PluginCall call) {
        String picture = call.getString("picture");
        if (picture != null && !picture.isEmpty()) {
            User user = dataService.getUser();
            dataService.storeUserImage(getContext(), user, picture);
            dataService.setUser(user);
        }
        call.resolve();
    }

}
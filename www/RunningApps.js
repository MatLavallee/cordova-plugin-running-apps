var exec = require('cordova/exec');

module.exports = {
  getRunningApps: function(successCallback, failureCallback) {
    exec(successCallback, failureCallback, "RunningApps", "getRunningApps", []);
  }
};

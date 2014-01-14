#import "CDVRunningApps.h"

@implementation CDVRunningApps

- (void)getRunningApps:(CDVInvokedUrlCommand*)command
{
  NSArray *runningApps = [self getRunningAppsList];
  CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:runningApps];
  [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

// Inspired by: http://forrst.com/posts/UIDevice_Category_For_Processes-h1H
- (NSArray*)getRunningAppsList
{
  int mib[4] = {CTL_KERN, KERN_PROC, KERN_PROC_ALL, 0};
  size_t miblen = 4;

  size_t size;
  int st = sysctl(mib, miblen, NULL, &size, NULL, 0);

  struct kinfo_proc * process = NULL;
  struct kinfo_proc * newprocess = NULL;

  do {

    size += size / 10;
    newprocess = realloc(process, size);

    if (!newprocess){

      if (process){
        free(process);
      }

      return nil;
    }

    process = newprocess;
    st = sysctl(mib, miblen, process, &size, NULL, 0);

  } while (st == -1 && errno == ENOMEM);

  if (st == 0){

    if (size % sizeof(struct kinfo_proc) == 0){
      int nprocess = size / sizeof(struct kinfo_proc);

      if (nprocess){

        NSMutableArray * array = [[NSMutableArray alloc] init];

        for (int i = nprocess - 1; i >= 0; i--){
          // A process is a running app when its p_flag is 18432
          // Source: http://stackoverflow.com/a/15976566/351398
          bool isProcessRunning = process[i].kp_proc.p_flag == 18432;
          if(!isProcessRunning) continue;

          NSString * processName = [[NSString alloc] initWithFormat:@"%s", process[i].kp_proc.p_comm];
          [array addObject:processName];
        }

        free(process);
        return array;
      }
    }
  }

  return nil;
}
@end

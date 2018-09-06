# Limbic-demo-project
Demo project to showcase some of the Stress SDK's functionality

## How to get started/Usage

In order to correctly compile, run: `pod install`.
Then, open the project's XCWorkspace in XCode and open `AppDelegate.swift`. In here, you'll find:

```
...
Limbic.apiKey = "YOUR_API_KEY"
...

```

Replace `"YOUR_API_KEY"` With the API key that was provided to you by one of the Limbic staff members.

## How to use the demo project

<img src="https://github.com/LimbicAI/Limbic-demo-project/blob/master/screenshot.png" width="364" height="638" />

The app displays Stress Values on a daily resolution. The most recent values being displayed on the right-hand side, working backwards to past values - right to left.

Screenshot above - Illustrates one week of data. We're displaying values from Thursday (extreme right) to the previous Friday (extreme left).

Screenshot below - Pressing on a data-point displays the Limbic values for that particular day.

<img src="https://github.com/LimbicAI/Limbic-demo-project/blob/master/datapoint.png" width="364" height="638" />


## Return values

```swift
"2018-05-29 23:00:00 +0000" = {
  confidence = "1.000001054754341";
  confidenceLevel = 2;
  stressIndex = 0;
  stressLevel = 4;
};
```

* `stressLevel` is the recommended way to report on a user's stress levels. The value can range from 1 to 7. Below is a breakdown of all possible values:
* `stress Index` is an index, as calculated from the person's own baseline on their stress level. Anything above 0 would mean *more stressed than average*, anything below *less stressed than average*.
* `confidence Level` can either be 1 or 2. `1` stands for *certain*, and a `2` stands for *uncertain*. This is the certainty about the stress prediction.
* `confidence Index` means the **confidence interval** in which we are 95% confident the `stressIndex` lies.


```bash
1 -- A very calm day
2 -- A calm day
3 -- A slightly calm day
4 -- A normal day
5 -- A slightly stressful day
6 -- A stressful day
7 -- A very stressful day
```  

## Troubleshooting

In the meantime, there are a few things you could do to help us work out what’s happened - 1) there’s a host of possible (but rare) instances where the Apple Watch won’t record (enough) hr data. Here’s how you can make sure to exclude those.

Check your settings:
* On your iPhone, in the Watch app, go to: My Watch (tab) > Privacy - turn on Heart Rate and Fitness Tracking.
* On your iPhone, go to: Settings > Privacy > Motion & Fitness - check that both Fitness Tracking and Health are enabled.

Check that you’ve set up the activity app (for help see: https://help.apple.com/watch/#/apd3bf6d85a6)

Please make sure your settings are set as follows:
* On your iPhone, in the Watch app, go to: My Watch (tab) > Passcode.
* Turn on each of Wrist Detection, Passcode and Unlock with iPhone.
* After putting it on your wrist, your Apple Watch will then unlock after whatever you do first: either unlocking your watch manually (by entering the passcode) or unlocking your iPhone.
* It will then remain unlocked (including when the screen is asleep) until you remove it from your wrist.
* When you remove your Apple Watch, it will lock automatically.

Close certain apps and restart both your iPhone and your Apple Watch:
* Close the Watch app, Activity app and Health app (if open) on your iPhone:
   * Double-click the Home button, then swipe up on each app preview to close the apps.
* Turn both devices off together, then restart your iPhone first:
   * Restart your iPhone (see: https://support.apple.com/en-us/HT201559)
   * Restart your Apple Watch (see: https://support.apple.com/en-us/HT204510)

It may also help to check that the back of your Apple Watch is clean (along with your wrist, which I'm sure is the case): https://support.apple.com/en-us/HT204522

If after this, we’re still getting unconfident measurements, we can take a look at your csv health data export and take a look at what’s going on.
* Open the Health app -> tap the profile button in the top right corner -> press ‘export health data’

As a hack, we are also aware the the ‘breath’ app on the Apple Watch is likely to trigger a heart-rate recording (and this might be a good way for you to start your Monday!)

Hope this helps :slightly_smiling_face:

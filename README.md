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

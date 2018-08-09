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

![alt tag](https://www.dropbox.com/s/1zi2qye5g2ckhlx/Screenshot%202018-08-09%2010.47.47.png)

The app is displaying Stress values per day, counting backward from today onwards.
In the image dispalyed here, we're counting backward from Thursday (see T on the right hand side) to the Friday before (see F on the left hand side).

When pressing on a datapoint, it will show the Limbic values.

![alt tag](https://www.dropbox.com/s/loq1loe496c0nr8/Screenshot%202018-08-09%2010.57.14.png)

## Return values

```swift
"2018-05-29 23:00:00 +0000" = {
  confidence = "1.000001054754341";
  confidenceLevel = 2;
  stressIndex = 0;
  stressLevel = 4;
};
```

* `confidence` means the **confidence interval** in which we are 95% confident the `stressIndex` lies.
* `confidenceLevel` can either be 1 or 2. `1` stands for *certain*, and a `2` stands for *uncertain*. This is the certainty about the stress prediction.
* `stressIndex` is an index, as calculated from the person's own baseline on their stress level. Anything above 0 would mean *more stressed than average*, anything below *less stressed than average*.
* `stressLevel` is the recommended way to report on a user's stress levels. The value can range from 1 to 7. Below is a breakdown of all possible values:

```bash
1 -- A very calm day
2 -- A calm day
3 -- A slightly calm day
4 -- A normal day
5 -- A slightly stressful day
6 -- A stressful day
7 -- A very stressful day
```  

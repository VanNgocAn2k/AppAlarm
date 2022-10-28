
# Ứng dụng Dồng hồ 
* Dựa trên ý tưởng từ [Link](https://play.google.com/store/apps/details?id=com.nhstudio.alarmioss&hl=vi&gl=US)

## Ảnh chụp màn hình

### Alarm
<kbd><img src=https://user-images.githubusercontent.com/105619244/197386114-d1f952ea-6658-4c40-8540-c5e5d0f42174.png alt=1 width="150" /> 
<img src=https://user-images.githubusercontent.com/105619244/197386116-bace87f2-2621-4bb8-a52a-6bef384b5b17.png alt=2 width="150" /> 
<img src=https://user-images.githubusercontent.com/105619244/197386118-2a5ccc75-13c1-4e08-ba01-39538df7882b.png alt=3 width="150" /> 
<img src=https://user-images.githubusercontent.com/105619244/197386119-3a5c7934-89db-4b6b-8c75-9323db078074.png alt=4 width="150" />
<img src=https://user-images.githubusercontent.com/105619244/197386121-b667fd7d-5d34-4977-92e8-8ea4c32528b5.png alt=5 width="150" />
```php
 func configDatePicker() {
        datePicker.frame = CGRect(x: 0, y: 50, width: self.view.frame.width, height: 200)
        datePicker.setValue(UIColor.white, forKeyPath: "textColor")
        datePicker.datePickerMode = .time
        datePicker.backgroundColor = .clear
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        view.addSubview(datePicker)
    }
 ```
### Stopwatch
<kbd><img src=https://user-images.githubusercontent.com/105619244/197386131-bdf36584-a3a7-4bc8-a0a0-3fa048af3eb7.png alt=6 width="150" /> 
<img src=https://user-images.githubusercontent.com/105619244/197386133-ce33093d-70d6-4d03-bdde-5ee929498574.png alt=7 width="150" />
### Timezone
<kbd><img src=https://user-images.githubusercontent.com/105619244/197386135-c06b1eeb-ec40-4bce-a5c1-c50edd82648d.png alt=8 width="150" />
<img src=https://user-images.githubusercontent.com/105619244/197386136-e14b5493-d53d-4e99-958d-2c11dfda2c43.png alt=9 width="150" /> 
### Timer
<kbd><img src=https://user-images.githubusercontent.com/105619244/197386156-9c0d70c3-76fc-49d2-9c47-cdc7f54d20e0.png alt=10 width="150" />
<img src=https://user-images.githubusercontent.com/105619244/197386157-417b02db-7e1e-492e-8079-3ed5b0b22156.png alt=11 width="150" />
<img src=https://user-images.githubusercontent.com/105619244/197386159-e3a86206-1d76-4408-9194-b4438376e0ce.png alt=12 width="150" /> 

## Thao tác

<kbd><img src=https://user-images.githubusercontent.com/105619244/198434020-b55542dc-5644-4126-8df9-5cebaeb33e36.gif alt=31 width="150" /> 
<img src=https://user-images.githubusercontent.com/105619244/198434124-3a0d0f24-ccc0-4711-85d3-85366da75ffd.gif alt=32 width="150" /> 
<img src=https://user-images.githubusercontent.com/105619244/198434132-82f3b151-67cc-47bf-88de-c6e1cd9fd885.gif alt=33 width="150" /> 
<img src=https://user-images.githubusercontent.com/105619244/198434138-1a4f0413-b646-4f4c-aaf6-7dccec3230c6.gif alt=34 width="150" /> 
<img src=https://user-images.githubusercontent.com/105619244/198434144-6eb8d85c-6824-43af-a6f4-de1e9b920cb6.gif alt=35 width="150" />







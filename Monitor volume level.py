import serial

# Serial settings
ser = serial.Serial(
    port='COM4',
    baudrate=115200,
    timeout=1
)

print("Connected to:", ser.name)

# Calibration constants (replace with your own)
m = -32.3058
c = 2726.7385

while True:
    try:
        line = ser.readline().decode('ascii').strip()
        if line != "":
            adc_value = float(line)

            # Convert Voltage -> Moisture / Volume
            volume =  (adc_value- c)/m

            print("ADC:", adc_value)
            print("Soil Moisture Volume:", round(volume,0))
            print("-----------------------")
            break

    except ValueError:
        print("Invalid data received")



print("Second attempt: Connected to:", ser.name)

# Calibration constants (replace with your own)

while True:
    try:
        line1 = ser.readline().decode('ascii').strip()
        if line1 != "":
            adc_value1 = float(line1)

            # Convert Voltage -> Moisture / Volume
            volume1 = m * adc_value1 + c

            print("Second attempt ADC:", adc_value1)
            print("Second attempt Soil Moisture Volume:", round(volume1,0))
            print("-----------------------")
            break

    except ValueError:
        print("Invalid data received")




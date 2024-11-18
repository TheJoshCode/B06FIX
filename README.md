## **Requirements**
- **Administrator privileges** are required to run this script.

---

## **Steps to Run the Script**

### 1. **Download the Script**
Download the batch file to your PC. The script will automatically search for the required folder structure on your system.

### 2. **Run the Script as Administrator**
Right-click the batch file and select **Run as administrator** to ensure it has the necessary privileges to install the service.

### 3. **Script Process**
- The script will search the entire **C:\ drive** for a folder named **"Call Of Duty"**.
- Once found, it will look for the **"Content"** subfolder inside it.
- The script will check for the **randgrid.sys** file in the **Content** folder. If it's missing, the script will halt and notify you.
- If everything is correct, the script will:
  - Remove any existing **atvi-randgrid_msstore** service if present.
  - Create the **atvi-randgrid_msstore** service using **randgrid.sys**.
  - Set the necessary service permissions.

---

## **Script Output**
- If the **Content** folder and **randgrid.sys** file are found, the script will proceed to create the service.
- If an issue is detected at any step, the script will notify you and halt.

---

## **Important Notes**
- This script only works if the **randgrid.sys** file is located inside the **Content** folder under any **Call Of Duty** installation.
- Ensure that you have the necessary files before running the script.

---

## **Troubleshooting**
If the script fails, ensure that:
- The **Call Of Duty** folder and the **Content** subfolder exist.
- The **randgrid.sys** file is present in the **Content** folder.
- You are running the script with **administrator privileges**.

---

## **Contact**
For any issues or questions, feel free to reach out for assistance.


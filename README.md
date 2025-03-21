# Introduction :

**easy_schedule** is a library to help with scheduling in your ruby-based system. 

First of all, there are some elements that must be understood before using this library. Here is the explanation:
- **Subject** is the name of the schedule that will be used in your system, for example if your subject name is **Doctor** then your schedule will be called **Doctor Scheduling**.
- **Config** is a setting for data in the scheduling system. In which there are settings for the subject name, maximum limit for adding subjects to the schedule, and the timezone you use.
- **Schedule** is your master scheduling data which you must prepare first before you can add subjects to the schedule. In it you have to specify **day**, **start_schedule**, **end_schedule**. For **timezone** it will be filled automatically based on the data in **timezone config**.
- **Subject Schedule** is the subjects listed in the schedule. For example, the **Subject Tono** is on the **Schedule** on **Monday at 10 AM-11 AM**.
- **Subject Cancel Schedule** is a note of a subject who is already on the schedule and is unable to attend the schedule. For example, **Subject Tono** has a **Schedule** on **Monday at 10 AM-11 AM**, but on 2025/03/17 Tono cannot attend.

In **easy_schedule** has several features, such as:
- **Add Subjects** to **Weekly Schedule**.
- **Add Subjects** to **Daily Schedule**.
- **Delete Subject** from **Selected Schedule**.
- **Terminate Subjects** from **Selected Schedule**. ( for example, if a **Subject** is **Terminated** on **2025/02/25**, the **Subject** will not appear in the schedule from that date. However, for dates before **25-02-2025**, the subject data will still be visible )
- **View Monthly Schedule**, including remaining empty slots in each schedule.
- **View List of Subjects** in each **Schedule**.
- **Deactivate the Schedule**. ( for example if the **Schedule** is **Deactivated** on **2025/02/25** then for this **Schedule** from this date onwards it will no longer appear. However, for dates before **25-02-2025**, the subject data will still be visible )

## How to install : 

Before installing this library, make sure some **Dependency Gems** are installed on your ruby ​​system. Here is the **Gem List**:

> gem 'pg'

To install this library, add this to your Gemfile :

> gem 'easy_schedule'

Or if you want to download this library to your computer, do this:

- Clone this library to your computer.
- Go to the **Easy Schedule** folder.
- Run this command to create a file with the extension **.gem** : 

> gem build easy_schedule.gemspec

- Now in your ruby ​​application, install the **.gem** file :

> gem install ../folder_path/easy_schedule-x.x.gem

Example :

> gem install ../Easy\ Schedule/easy_schedule-1.0.gem

## How to use : 

After the library is installed on your Ruby system, do the following steps: 

### Create a scheduling database (do this if you are installing this library for the first time)

- Log in to your **PostgreSQL Clients**, then **Create a Database** that we will use in the library : 

> CREATE DATABASE your_database_name

Example :

> CREATE DATABASE easy_schedule

### Require library

- Require library where you want to use it. Example : 

> require 'easy_schedule'

### Open connection with postgresql

- To be able to connect to the data in the **Scheduling Database**, do this first :

> connection = EasySchedule.new(postgresql_connection_strings)

Example : 

> connection = EasySchedule.new("postgresql://guest:guest@127.0.0.1:5432/easy_schedule?sslmode=require")

### Insert configs (do this if you are installing this library for the first time)

To be able to run this library, **Config Data** is needed first. Do this :

> connection.config_seed(subject_name, limit_schedule, timezone)

Example :

> connection.config_seed('Doctor')

or

> connection.config_seed('Doctor', '20')

or 

> connection.config_seed('Doctor', '20', 'America/New_York')


Note :

- **subject_name** (required) : **subject_name** is the name of the schedule, for example the subject is **Doctor** then it will be considered as the **Doctor schedule**.
- **limit_schedule** (optional) : **limit_schedule** is the **maximum limit** that each schedule can add a subject. Will be filled by default **10** if not filled.
- **timezone** (optional) : **timezone** set for the time on the schedule. Will be filled by default **Asia/Jakarta** if not filled.

### List configs

If you want to see the configs data, then do this :

> connection.config_list(page, limit)

Example : 

> connection.config_list

or

> connection.config_list(1)

or

> connection.config_list(1, 5)

Note : 

- **page** (optional) : **page** is the page whose data you are currently opening. Will be filled by default **1** if not filled.
- **limit** (optional) : **limit** is the amount of data you want to display. Will be filled by default **10** if not filled.

### Bulk insert subjects

To add data subjects can be multiple data at once. Here's how :

> connection.insert_bulk_data_subject(bulk_data)

Example : 

> connection.insert_bulk_data_subject([{ name: 'Tono', phone_number: '+62xxxxxxxxxxx1', gender: 'MALE' }, { name: 'Indah', phone_number: '+62xxxxxxxxxxx2', gender: 'FEMALE' }])

Note : 

- **bulk_data** (required) : **bulk_data** is an array of **subject** data that will be inserted into the database.
    - **name** : is the **name** of the **subjects**.
    - **phone_number** (unique) : is the **phone_number** of the **subjects**.
    - **gender** : is the **gender** of the **subjects**. Here are the **gender** you can choose from : 
        * 'MALE'
        * 'FEMALE'

### List subjects

If you want to see the subjects data, then do this :

> connection.subject_list(page, limit)


Example : 

> connection.subject_list

or

> connection.subject_list(1)

or

> connection.subject_list(1, 5)

Note : 

- **page** (optional) : **page** is the page whose data you are currently opening. Will be filled by default **1** if not filled.
- **limit** (optional) : **limit** is the amount of data you want to display. Will be filled by default **10** if not filled.

### Bulk insert schedules

To add data schedules can be multiple data at once. Here's how :

> connection.insert_bulk_data_schedule(bulk_data)

Example :

> connection.insert_bulk_data_schedule([{ day: 'MONDAY', start_schedule: '10 AM', end_schedule: '11 AM' }, { day: 'MONDAY', start_schedule: '2 PM', end_schedule: '4 PM' }])

Note : 

- **bulk_data** (required) : **bulk_data** is an array of **schedule** data that will be inserted into the database.
    - **day** : **day** is the day of the schedule. Here are the **day** you can choose from : 
        * 'SUNDAY'
        * 'MONDAY'
        * 'TUESDAY'
        * 'WEDNESDAY'
        * 'THURSDAY'
        * 'FRIDAY'
        * 'SATURDAY'
    - **start_schedule** : **start_schedule** is the **start time** of the schedule. Here are the **start_schedule** you can choose from : 
        * '1 AM', '2 AM', ..., '12 AM'
        * '1 PM', '2 PM', ..., '12 PM'
    - **end_schedule** : **end_schedule** is the **end time** of the schedule. Here are the **end_schedule** you can choose from : 
        * '1 AM', '2 AM', ..., '12 AM'
        * '1 PM', '2 PM', ..., '12 PM'

### List schedules

If you want to see the schedules data, then do this :

> connection.schedule_list(page, limit)

Example :

connection.schedule_list

or

> connection.schedule_list(1)

or

> connection.schedule_list(1, 5)

Note : 

- **page** (optional) : **page** is the page whose data you are currently opening. Will be filled by default **1** if not filled.
- **limit** (optional) : **limit** is the amount of data you want to display. Will be filled by default **10** if not filled.
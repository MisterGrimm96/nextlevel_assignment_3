# Vehicle Rental System

- A DB query collection to help and grow vehicle rental business

## ERD Link

- erd [link](https://drawsql.app/draw?t=10c00057-615c-4d00-a168-da5cdef38ded&view=1) for better understanding of the relations between the tables

## Tables Structures

## users

| Column Name |  Data Type   |
| :---------: | :----------: |
|   user_id   |    serial    |
|    name     | varchar(200) |
|    email    | varchar(200) |
|    phone    | varchar(20)  |
|    role     | varchar(10)  |

## vehicles

|     Column Name     |   Data Type   |
| :-----------------: | :-----------: |
|     vehicle_id      |    serial     |
|        name         | varchar(200)  |
|        type         |  varchar(50)  |
|        model        |      int      |
| registration_number | varchar(100)  |
|    rental_price     | decimal(10,2) |
|       status        |  varchar(50)  |

## bookings

| Column Name |   Data Type   |
| :---------: | :-----------: |
| booking_id  |    serial     |
|   user_id   |      int      |
| vehicle_id  |      int      |
| start_date  |     date      |
|  end_date   |     date      |
|   status    |  varchar(50)  |
| total_cost  | decimal(10,2) |

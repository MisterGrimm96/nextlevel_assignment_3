create table if not exists users (
  user_id serial primary key,
  name varchar(200) not null,
  email varchar(200) unique not null,
  phone varchar(20),
  role varchar(10) check (role in ('admin', 'customer'))
);

-- ===============================================================
create table if not exists vehicles (
  vehicle_id serial primary key,
  name varchar(200) not null,
  type varchar(50) check (type in ('car', 'bike', 'truck')),
  model int,
  registration_number varchar(100) unique not null,
  rental_price decimal(10, 2) not null,
  status varchar(50) check (status in ('available', 'rented', 'maintenance'))
);

-- ===============================================================
create table if not exists bookings (
  booking_id serial primary key,
  user_id int not null references users (user_id),
  vehicle_id int not null references vehicles (vehicle_id),
  start_date date not null,
  end_date date not null,
  status varchar(50) check (
    status in ('pending', 'confirmed', 'completed', 'cancelled')
  ),
  total_cost decimal(10, 2) not null
);

-- =========================
-- Sample Data for users
-- =========================
insert into
  users (name, email, phone, role)
values
  (
    'Alice Johnson',
    'alice@example.com',
    '1234567890',
    'customer'
  ),
  (
    'Bob Smith',
    'bob@example.com',
    '0987654321',
    'admin'
  ),
  (
    'Charlie Brown',
    'charlie@example.com',
    '1122334455',
    'customer'
  ),
  (
    'David Lee',
    'david@example.com',
    '2233445566',
    'customer'
  ),
  (
    'Emma Watson',
    'emma@example.com',
    '3344556677',
    'customer'
  );

-- =========================
-- Sample Data for vehicles
-- =========================
insert into
  vehicles (
    name,
    type,
    model,
    registration_number,
    rental_price,
    status
  )
values
  (
    'Toyota Corolla',
    'car',
    2022,
    'ABC-123',
    50.00,
    'available'
  ),
  (
    'Honda Civic',
    'car',
    2021,
    'DEF-456',
    60.00,
    'rented'
  ),
  (
    'Yamaha R15',
    'bike',
    2023,
    'GHI-789',
    30.00,
    'available'
  ),
  (
    'Ford F-150',
    'truck',
    2020,
    'JKL-012',
    100.00,
    'maintenance'
  ),
  (
    'Suzuki Gixxer',
    'bike',
    2022,
    'MNO-345',
    35.00,
    'available'
  ),
  (
    'Tesla Model 3',
    'car',
    2024,
    'TES-999',
    120.00,
    'available'
  );

-- =========================
-- Sample Data for bookings
-- =========================
insert into
  bookings (
    user_id,
    vehicle_id,
    start_date,
    end_date,
    status,
    total_cost
  )
values
  (
    1,
    2,
    '2023-10-01',
    '2023-10-05',
    'completed',
    240.00
  ),
  (
    1,
    2,
    '2023-11-01',
    '2023-11-03',
    'completed',
    120.00
  ),
  (
    3,
    2,
    '2023-12-01',
    '2023-12-02',
    'confirmed',
    60.00
  ),
  (
    1,
    1,
    '2023-12-10',
    '2023-12-12',
    'pending',
    100.00
  ),
  (
    4,
    3,
    '2024-01-05',
    '2024-01-07',
    'completed',
    90.00
  ),
  (
    5,
    6,
    '2024-02-01',
    '2024-02-03',
    'confirmed',
    240.00
  ),
  (
    3,
    5,
    '2024-03-10',
    '2024-03-12',
    'cancelled',
    70.00
  );

-- ###############
-- Tasks
-- #############3
-- 1. booking info along with customer name and vehicle name
select
  u.name,
  v.name
from
  bookings as b
  inner join users as u using (user_id)
  inner join vehicles as v using (vehicle_id);

-- ============================================================================================
-- 2. vehicles that have never been booked
select
  *
from
  vehicles as v
where
  not exists (
    select
      *
    from
      bookings as b
    where
      v.vehicle_id = b.vehicle_id
  );

-- ============================================================================================
-- 3. retrieve all the vehicles with a specific type
create function get_vehicles_by_type (vehicle_type varchar(50)) returns setof vehicles language sql as $$
  select *
  from vehicles
  where type = vehicle_type;
$$;

select
  *
from
  get_vehicles_by_type ('car');
-- drop function get_vehicles_by_type (varchar)

-- ============================================================================================
-- 4. Find the total number of bookings for each vehicle and display only those vehicles that have more than 2 bookings.
select
  v.name as "vehicle_name",
  count(b.booking_id) "total_bookings"
from
  vehicles as v
  inner join bookings as b using (vehicle_id)
group by
  v.name
having 
  count (b.booking_id) > 2C;

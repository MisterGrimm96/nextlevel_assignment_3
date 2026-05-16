CREATE TABLE IF NOT EXISTS users (
    user_id serial PRIMARY KEY,
    name varchar(200) NOT NULL,
    email varchar(200) UNIQUE NOT NULL,
    phone varchar(20),
    role varchar(10) CHECK (ROLE IN ('admin', 'customer'))
);

-- ===============================================================
CREATE TABLE IF NOT EXISTS vehicles (
    vehicle_id serial PRIMARY KEY,
    name varchar(200) NOT NULL,
    type varchar(50) CHECK (type IN ('car', 'bike', 'truck')),
    model int,
    registration_number varchar(100) UNIQUE NOT NULL,
    rental_price decimal(10, 2) NOT NULL,
    status varchar(50) CHECK (status IN ('available', 'rented', 'maintenance'))
);

-- ===============================================================
CREATE TABLE IF NOT EXISTS bookings (
    booking_id serial PRIMARY KEY,
    user_id int NOT NULL REFERENCES users (user_id),
    vehicle_id int NOT NULL REFERENCES vehicles (vehicle_id),
    start_date date NOT NULL,
    end_date date NOT NULL,
    status varchar(50) CHECK (status IN ('pending', 'confirmed', 'completed', 'cancelled')),
    total_cost decimal(10, 2) NOT NULL
);

-- =========================
-- Sample Data for users
-- =========================
INSERT INTO users (name, email, phone, role)
VALUES
    ('Alice Johnson', 'alice@example.com', '1234567890', 'customer'),
    ('Bob Smith', 'bob@example.com', '0987654321', 'admin'),
    ('Charlie Brown', 'charlie@example.com', '1122334455', 'customer'),
    ('David Lee', 'david@example.com', '2233445566', 'customer'),
    ('Emma Watson', 'emma@example.com', '3344556677', 'customer');

-- =========================
-- Sample Data for vehicles
-- =========================
INSERT INTO vehicles (name, type, model, registration_number, rental_price, status)
VALUES
    ('Toyota Corolla', 'car', 2022, 'ABC-123', 50.00, 'available'),
    ('Honda Civic', 'car', 2021, 'DEF-456', 60.00, 'rented'),
    ('Yamaha R15', 'bike', 2023, 'GHI-789', 30.00, 'available'),
    ('Ford F-150', 'truck', 2020, 'JKL-012', 100.00, 'maintenance'),
    ('Suzuki Gixxer', 'bike', 2022, 'MNO-345', 35.00, 'available'),
    ('Tesla Model 3', 'car', 2024, 'TES-999', 120.00, 'available');

-- =========================
-- Sample Data for bookings
-- =========================
INSERT INTO bookings (user_id, vehicle_id, start_date, end_date, status, total_cost)
VALUES
    (1, 2, '2023-10-01', '2023-10-05', 'completed', 240.00),
    (1, 2, '2023-11-01', '2023-11-03', 'completed', 120.00),
    (3, 2, '2023-12-01', '2023-12-02', 'confirmed', 60.00),
    (1, 1, '2023-12-10', '2023-12-12', 'pending', 100.00),
    (4, 3, '2024-01-05', '2024-01-07', 'completed', 90.00),
    (5, 6, '2024-02-01', '2024-02-03', 'confirmed', 240.00),
    (3, 5, '2024-03-10', '2024-03-12', 'cancelled', 70.00);

-- ###############
-- Tasks
-- #############3
-- 1. booking info along with customer name and vehicle name
SELECT
    u.name,
    v.name
FROM
    bookings AS b
    INNER JOIN users AS u USING (user_id)
    INNER JOIN vehicles AS v USING (vehicle_id);

-- ============================================================================================
-- 2. vehicles that have never been booked
SELECT
    *
FROM
    vehicles AS v
WHERE
    NOT EXISTS (
        SELECT
            *
        FROM
            bookings AS b
        WHERE
            v.vehicle_id = b.vehicle_id);

-- ============================================================================================
-- 3. retrieve all the vehicles with a specific type
CREATE FUNCTION get_vehicles_by_type (vehicle_type varchar(50))
    RETURNS SETOF vehicles
    LANGUAGE sql
    AS $$
    SELECT
        *
    FROM
        vehicles
    WHERE
        type = vehicle_type;
$$;

SELECT
    *
FROM
    get_vehicles_by_type ('car');

-- drop function get_vehicles_by_type (varchar)
-- ============================================================================================
-- 4. Find the total number of bookings for each vehicle and display only those vehicles that have more than 2 bookings.
SELECT
    v.name AS "vehicle_name",
    count(b.booking_id) "total_bookings"
FROM
    vehicles AS v
    INNER JOIN bookings AS b USING (vehicle_id)
GROUP BY
    v.name
HAVING
    count(b.booking_id) > 2;


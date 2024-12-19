import mysql.connector
from mysql.connector import Error

# Connect to the MySQL database
def connect_to_database():
    try:
        connection = mysql.connector.connect(
            host="localhost",  # Replace with your database host
            user="root",       # Replace with your MySQL username
            password="password", # Replace with your MySQL password
            database="little_lemon"  # Replace with your database name
        )
        if connection.is_connected():
            print("Successfully connected to the database")
            return connection
    except Error as e:
        print(f"Error: {e}")
        return None

# Procedure to get maximum booking quantity
def get_max_quantity(cursor):
    query = "SELECT MAX(quantity) FROM bookings;"
    cursor.execute(query)
    result = cursor.fetchone()
    print(f"Maximum booking quantity: {result[0]}")

# Procedure to manage a booking
def manage_booking(cursor, booking_id, status):
    query = "UPDATE bookings SET status = %s WHERE id = %s;"
    cursor.execute(query, (status, booking_id))
    print(f"Booking {booking_id} updated to status '{status}'.")

# Procedure to add a new booking
def add_booking(cursor, customer_name, date, quantity, status):
    query = """
        INSERT INTO bookings (customer_name, date, quantity, status)
        VALUES (%s, %s, %s, %s);
    """
    cursor.execute(query, (customer_name, date, quantity, status))
    print("New booking added successfully.")

# Procedure to cancel a booking
def cancel_booking(cursor, booking_id):
    query = "UPDATE bookings SET status = 'Cancelled' WHERE id = %s;"
    cursor.execute(query, (booking_id,))
    print(f"Booking {booking_id} has been cancelled.")

# Main function
def main():
    connection = connect_to_database()
    if connection:
        cursor = connection.cursor()

        # Example operations
        get_max_quantity(cursor)
        add_booking(cursor, "John Doe", "2024-12-20", 3, "Confirmed")
        manage_booking(cursor, 1, "Completed")
        cancel_booking(cursor, 2)

        # Commit changes
        connection.commit()
        cursor.close()
        connection.close()

if __name__ == "__main__":
    main()

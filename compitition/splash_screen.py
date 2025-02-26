import tkinter as tk
from tkinter import ttk
import time

# Function to show the main calculator window
def open_calculator():
    splash.destroy()  # Close splash screen
    calculator_window()  # Open main calculator

# Function for the calculator window
def calculator_window():
    root = tk.Tk()
    root.title("Calculator")

    entry = tk.Entry(root, font=("Arial", 20), justify="right")
    entry.pack(padx=10, pady=10)

    root.mainloop()

# Create the splash screen
splash = tk.Tk()
splash.title("Loading...")

# Set splash screen size
splash.geometry("300x200")
splash.configure(bg="lightblue")

# Center the splash screen
screen_width = splash.winfo_screenwidth()
screen_height = splash.winfo_screenheight()
x_position = (screen_width // 2) - (300 // 2)
y_position = (screen_height // 2) - (200 // 2)
splash.geometry(f"300x200+{x_position}+{y_position}")

# Add a loading label
label = ttk.Label(splash, text="Loading Calculator...", font=("Arial", 14), background="lightblue")
label.pack(expand=True)

# Close splash after 3 seconds and open main window
splash.after(3000, open_calculator)

splash.mainloop()

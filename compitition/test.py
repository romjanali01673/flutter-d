import customtkinter as ctk

def on_click(button_text):

    if button_text == "AC":
        entry_var.set("")
    elif button_text=="C":
        text = entry_var.get()
        text = text[:-1]
        entry_var.set(text)
    elif button_text == "=":
        try:
            result = eval(entry_var.get())
            entry_var.set(result)
        except Exception:
            entry_var.set("Error")
    else:
        entry_var.set(entry_var.get() + button_text)

# Set appearance mode and color theme
# ctk.set_appearance_mode("System")  # Modes: "System", "Dark", "Light"
# ctk.set_default_color_theme("blue")  # Themes: "blue", "green", "dark-blue"

# Create the main window
root = ctk.CTk()
root.title("Calculator 677844")
root.geometry("300x440")
# root.resizable(False, False)


# Entry widget for displaying the input and results
entry_var = ctk.StringVar()
entry = ctk.CTkEntry(
    root,
    textvariable=entry_var,
    font=("Arial", 20),
    justify='right',
    width=280,
    height=50,
    corner_radius=10,
)
entry.pack(pady=10)

# This list defines the layout of the calculator buttons.
buttons = [
    ("AC", "(", ")", "C",),
    ("1", "2", "3", "/",),
    ("4", "5", "6", "*",),
    ("7", "8", "9", "-",),
    (".", "0", "=", "+",),
]



def getColor(button_text):
    if button_text=="AC":
        return "red"
    elif button_text=="C":
        return "#ff4000"
    elif button_text=="=":
        return "grey"
    elif button_text=="(" or button_text==")":
        return "darkblue"
    elif button_text=="+" or button_text=="-" or button_text=="*" or button_text=="/":
        return "#ff8000"
    else:
        return "blue"
    
# Frame to hold the buttons
button_frame = ctk.CTkFrame(root)
button_frame.pack(fill='both', expand=True, padx=10, pady=10)

# Create and place the buttons
for row in buttons:
    row_frame = ctk.CTkFrame(button_frame)
    row_frame.pack(fill='both', expand=True)
    print(row)
    for button_text in row:
        btn = ctk.CTkButton(
            row_frame,
            text=button_text,
            font=("Arial", 18),
            command=lambda text=button_text: on_click(text),
            corner_radius=20,  # Rounded corners
            width=60,
            height=60,
            fg_color= getColor(button_text),  # Background color
            hover_color="darkblue",  # Background color on hover
        )
        btn.pack(side='left', fill='both', expand=True, padx=5, pady=5)

# Run the application
root.mainloop()
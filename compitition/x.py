import customtkinter as ctk

# def on_click(button_text):
#     if(button_text=='C'):
#     else:
        

root = ctk.CTk()
root.geometry("300x440")
root.title("Debug Calculator")
root.resizable( False,False)

input_var = ctk.StringVar()
entry = ctk.CTkEntry(
    root,
    textvariable= input_var,
    font=("Arial", 20),
    justify="right",
    width=280,
    height=50,
    corner_radius=10,
)
entry.pack(pady=10)

buttons =[

    ("AC", "(", ")","C"),
    ("1", "2", "3","/"),
    ("4", "5", "6","*"),
    ("7", "8", "9","-"),
    (".", "0", "=","+"),
]

def getColor(button_text):
    if(button_text=="AC"):
        return "red"
    elif (button_text=='C'):
        return "red"
    elif (button_text=='(' or button_text==')'):
        return "orange"
    elif button_text=="+" or button_text=='-' or button_text=='*' or button_text=='/':
        return "orange"
    else:
        return "blue"

getColor("sdf")

button_frame = ctk.CTkFrame(root)
button_frame.pack(fill="both", expand = True, padx=10, pady=10)

for row in buttons:
    row_frame=ctk.CTkFrame(butt)
root.mainloop()
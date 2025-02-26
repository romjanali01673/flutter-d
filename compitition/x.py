import customtkinter as ctk
import math
import re

# Note:  -----

# "2^3".replace("^", "**")
# √ = math.sqrt(x)
# ! = math.factorial(x) 
# ^ = **
# % = * 1/100 
# log(x) = math.log(x)/math.log(10)
# sin(x) = math.sin(x)
# cos(x) = math.cos(x)
# ten(x) = math.tan(x)
# exp = math.exp(x)  """e(2) => "*100"
# π = 3.1415926536


def replace_percentage(expression):
    # Use regex to replace "%" with "%*" when it's between digits
    return re.sub(r'(\d+)%(\d+)', r'\1%*\2', expression)

def on_click(button_text):
    if(button_text=='AC'):
        input_var.set("")
    elif (button_text=="C"):
        text = button_text.get()
        text=text[:-1]
        button_text.set(text)
    elif (button_text=='='):
        try:
            resilt  = eval(input_var.get())
            # resilt  = eval("math.e(2)")
            input_var.set(resilt)
        except Exception:
            input_var.set("Error")
    else:
        input_var.set(input_var.get()+button_text)
         

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


button_frame = ctk.CTkFrame(root)
button_frame.pack(fill="both", expand = True, padx=10, pady=10)

for row in buttons:
    row_frame=ctk.CTkFrame(button_frame)
    row_frame.pack(fill="both", expand = True)
    for button_text in row:
        btn = ctk.CTkButton(
            row_frame,
            text=button_text,
            font=("Arial", 20),
            command=lambda text=button_text: on_click(text),
            corner_radius=20,
            fg_color=getColor(button_text),
            hover_color="darkblue",
            width=60,
            height=60,
        )
        btn.pack(side="left", fill="both", expand=True, padx=5, pady=5)
root.mainloop()
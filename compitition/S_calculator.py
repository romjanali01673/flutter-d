import math
import re
import customtkinter as ctk

# gor factorial value
def factorial(input):
    # 6.00 or 6.90
    if input.is_integer(): 
        return math.factorial(int(input))
    else:
        return "x"
    
# fix factorial format here
def fix_factorial_format(input):
    res = input
    a = input.find("!")
    if(a != -1):
        res= input[:a]+")"+input[a+1:]
        r=0
        l=0
        i = a-1
        while True:
            if(i==-1):
                res = "factorial("+res
                break
            elif(l==r and (input[i]=="+" or input[i]=="-" or input[i]=="*" or input[i]=="/")):
                print("hii")
                res = res[:i+1]+"factorial("+res[i+1:]
                break
            elif res[i]=="(":
                l+=1
            elif res[i]==")":
                r+=1

            # decrementing i         
            i-=1
    if(res.find("!")==-1):
        return res
    else:
        return fix_factorial_format(res)

# fix colse paranthasis 
def fix_paranthacis(input_var):
    l=0
    r=0
    for i in input_var:
        if(i=="("):
            l=l+1
        elif(i==")"):
            r=r+1
    
    if(l>r):
        how = l-r
        while how>0:
            how-=1
            input_var+=")"

    return input_var

#  fix visual format to requerid eval format
def prepare(input_text):
    input_text = fix_factorial_format(input_text)
    input_text = fix_paranthacis(input_text)
    input_text = fix_paranthacis(input_text)

    input_text = re.sub(r'(\d+)%(\d+)', r'\1%*\2', input_text)

    input_text = input_text.replace("^", "**")

    input_text = input_text.replace("√", "math.sqrt")
    input_text = input_text.replace("π", "3.1415926536")
    input_text = input_text.replace("%", "*1/100")

    input_text = input_text.replace("log", "(1/math.log(10))* math.log")
    input_text = input_text.replace("sin", "math.sin")
    input_text = input_text.replace("cos", "math.cos")
    input_text = input_text.replace("tan", "math.tan")
    
    return input_text

# convart decimal to binary
def decimal_to_binary(num_str):
    
    try:
        num = float(num_str)  # Convert input to float
        if num.is_integer():  
            return bin(int(num))[2:]  # Convert integer part to binary
        else:
            return "Error Foloating value"
    except Exception:
        return "Error"


def on_click(button_text):

    if button_text == "AC":
        entry_var.set("")
    elif button_text=="C":
        text = entry_var.get()
        text = text[:-1]
        entry_var.set(text)
    
    elif button_text=="√":
        entry_var.set(entry_var.get() + "√(")
    elif button_text=="log":
        entry_var.set(entry_var.get() + "log(")
    elif button_text=="log":
        entry_var.set(entry_var.get() + "log(")

    elif button_text=="sin":
        entry_var.set(entry_var.get() + "sin(")
    elif button_text=="cos":
        entry_var.set(entry_var.get() + "cos(")
    elif button_text=="tan":
        entry_var.set(entry_var.get() + "tan(")
    
    elif button_text=="log":
        entry_var.set(entry_var.get() + "log(")

    elif button_text=="D/B":
        entry_var.set(decimal_to_binary(entry_var.get()))

    elif button_text=="x²":
        entry_var.set(entry_var.get() + "^2")
    elif button_text=="xʸ":
        entry_var.set(entry_var.get() + "^(")

    elif button_text=="π":
        entry_var.set(entry_var.get() + "π")

    elif button_text == "=":
        print(entry_var.get())
        entry_var.set(prepare(entry_var.get()))
        print(entry_var.get())
        try:
            result = eval(entry_var.get())
            entry_var.set(result)
        except Exception:
            entry_var.set("Error")
    else:
        entry_var.set(entry_var.get() + button_text)


# Create the main window
root = ctk.CTk()
root.title("Calculator 677844")
root.geometry("300x580")
root.configure(fg_color="black")
root.resizable(False, False)


# Entry widget for displaying the input and results
entry_var = ctk.StringVar()
entry = ctk.CTkEntry(
    root,
    textvariable=entry_var,
    font=("Arial", 20),
    justify='right',
    width=280,
    height=50,
    state="readonly",
    corner_radius=10,
    
)
entry.pack(pady=10)

# This list defines the layout of the calculator buttons.
buttons = [
    ("AC", "(", ")", "C",),
    ("sin", "cos", "tan", "xʸ",),
    ("log", "√", "π", "x²",),
    ("D/B", "%", "!", "+",),
    ("1", "2", "3", "/",),
    ("4", "5", "6", "*",),
    ("7", "8", "9", "-",),
    (".", "0", "=",),
]


def getWidth(button_text):
    if(button_text=="="):
        return 120
    else:
        return 60

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
            corner_radius=15,  # Rounded corners
            width=getWidth(button_text),
            # height=50, 
            fg_color= getColor(button_text),  # Background color
            hover_color="darkblue",  # Background color on hover
        )
        btn.pack(side='left', fill='both', expand=True, padx=5, pady=5)

# Run the application
root.mainloop()

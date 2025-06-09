import os


def generate_txt_files():
    # Get user input for the group name
    group_name = input("Enter the group name (e.g., IT): ").strip()

    # Get user input for the range
    while True:
        try:
            range_input = input("Enter the range (e.g., 5-15): ").strip()
            start, end = map(int, range_input.split('-'))
            if start > end or start < 1:
                print("Invalid range! Please enter a valid range (e.g., 5-15).")
                continue
            break
        except ValueError:
            print("Invalid input format! Please enter the range as 'start-end' (e.g., 5-15).")

    # Create a folder to store the files
    output_folder = "generated_groups"
    os.makedirs(output_folder, exist_ok=True)

    # Generate TXT files within the specified range
    for i in range(start, end + 1):
        file_name = f"{group_name}{i}.txt"
        file_path = os.path.join(output_folder, file_name)
        with open(file_path, "w") as file:
            file.write(f"This is {file_name}")  # Placeholder content
        print(f"Created: {file_name}")

    print(f"\nTXT files successfully created in the '{output_folder}' folder.")


# Run the script
generate_txt_files()

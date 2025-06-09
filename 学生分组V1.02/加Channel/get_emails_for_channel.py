import json
import csv
import os

# 获取 Python 脚本所在目录
script_dir = os.path.dirname(os.path.abspath(__file__))

# 定义输入和输出文件夹（均为 Python 文件所在目录）
input_folder = os.path.join(script_dir, "generated_groups")
output_folder = os.path.join(script_dir, "output_csvs")

# 确保输出文件夹存在
os.makedirs(output_folder, exist_ok=True)


def read_txt_file(file_path):
    """ 读取 TXT 文件并解析 JSON 数据 """
    try:
        with open(file_path, 'r', encoding='utf-8') as file:
            data = file.read()
        return json.loads(data)  # 假设 TXT 文件内容是 JSON 格式
    except (json.JSONDecodeError, FileNotFoundError) as e:
        print(f"Error reading {file_path}: {e}")
        return None


def process_and_write_csv(input_file, output_file):
    """ 解析 JSON 并写入 CSV 文件 """
    data = read_txt_file(input_file)
    if data is None:
        return

    emails = [["email"]]  # CSV 第一行

    for group in data:
        for user in group.get("users", []):
            student_number = user.get("username", "").lstrip("z")
            if student_number.isdigit():  # 确保是有效的学号
                emails.append([f"z{student_number}@ad.unsw.edu.au"])

    # 写入 CSV
    with open(output_file, 'w', newline='', encoding='utf-8') as file:
        writer = csv.writer(file)
        writer.writerows(emails)


def batch_process_txt_to_csv():
    """ 批量处理所有 TXT 文件 """
    for filename in os.listdir(input_folder):
        if filename.endswith(".txt"):
            print(filename)
            input_path = os.path.join(input_folder, filename)
            output_path = os.path.join(output_folder, filename.replace(".txt", ".csv"))
            process_and_write_csv(input_path, output_path)
            print(f"Processed {filename} -> {output_path}")


# 执行批量转换
batch_process_txt_to_csv()
print(f"批量处理完成，CSV 文件保存在: {output_folder}")

import json
import csv
import os

# 获取 Python 脚本所在目录
script_dir = os.path.dirname(os.path.abspath(__file__))

# 定义输入文件夹（Python 文件所在目录）
#input_folder = script_dir
input_folder = os.path.join(script_dir, "generated_groups")


# 定义输出 CSV 文件路径
output_csv = os.path.join(script_dir, "merged_output.csv")


def read_txt_file(file_path):
    """ 读取 TXT 文件并解析 JSON 数据 """
    try:
        with open(file_path, 'r', encoding='utf-8') as file:
            data = file.read()
        return json.loads(data)  # 假设 TXT 文件内容是 JSON 格式
    except (json.JSONDecodeError, FileNotFoundError) as e:
        print(f"Error reading {file_path}: {e}")
        return None


def process_txt_files():
    """ 批量处理所有 TXT 文件，并写入一个 CSV 文件 """
    emails = [["email"]]  # 第一行表头

    for filename in os.listdir(input_folder):
        if filename.endswith(".txt"):
            input_path = os.path.join(input_folder, filename)
            data = read_txt_file(input_path)
            if data is None:
                continue

            for group in data:
                for user in group.get("users", []):
                    student_number = user.get("username", "").lstrip("z")
                    if student_number.isdigit():  # 确保是有效的学号
                        emails.append([f"z{student_number}@ad.unsw.edu.au"])

    # 如果有数据，写入 CSV
    if len(emails) > 1:
        with open(output_csv, 'w', newline='', encoding='utf-8') as file:
            writer = csv.writer(file)
            writer.writerows(emails)
        print(f"合并完成，所有数据已写入 {output_csv}")
    else:
        print("未找到有效数据，未生成 CSV 文件")


# 执行合并转换
process_txt_files()
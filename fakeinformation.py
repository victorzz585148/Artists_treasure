import numpy as np

# 調整資料列以匹配欄位名稱的數量
data_np_fixed = np.array([["null", "2024-09-25", "Self portrait as a painter", "Oil Painting", "65.1", "50", "1888", "null", 
                           "self-portrait", "Van Gogh presented himself in this self-portrait as a painter, holding a palette and paintbrushes behind his easel. He showed that he was a modern artist by using a new painting style, with bright, almost unblended colours. The palette contains the complementary colour pairs red/green, yellow/purple and blue/orange – precisely the colours Van Gogh used for this painting. He laid these pairs down side by side to intensify one another: the blue of his smock, for instance, and the orange-red of his beard.", "4", "null", 
                           "梵谷博物館", r"C:\Users\LTU\Desktop\Media\Self portrait as a painter.jpg", "1"]])

columns_np = ["AK_ID", "AK_DATE", "AK_NAME", "AK_MATERIAL", "AK_SIZE", "AK_SIGNATURE_Y", "AK_SIGNATURE_M", 
              "AK_THEME", "AK_INTRODUCE", "AK_TIMES", "AK_RACETIMES", "AK_LOCATION", "AK_MEDIA", "AK_STATE", "AK_REMARK"]

# 將資料和欄位名稱合併
data_with_header_fixed = np.vstack([columns_np, data_np_fixed])

# 保存成CSV文件
file_path = 'C:/Users/User/Desktop/Artists_treasure/virtual_data_np_fixed.csv'
np.savetxt(file_path, data_with_header_fixed, delimiter=",", fmt='%s', encoding='utf-8')


file_path
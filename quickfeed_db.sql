-- ========================================================
-- KHỞI TẠO CƠ SỞ DỮ LIỆU VÀ BẢNG (LEGACY SCRIPT)
-- ========================================================
CREATE DATABASE IF NOT EXISTS quickfeed_db;
USE quickfeed_db;

-- Xóa bảng nếu đã tồn tại để làm lại từ đầu
DROP TABLE IF EXISTS Posts;

-- Tạo bảng Posts
CREATE TABLE Posts (
    post_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    content TEXT,
    post_type VARCHAR(10), -- Chỉ chứa 3 giá trị: 'TEXT', 'IMAGE', 'VIDEO'
    is_visible BOOLEAN DEFAULT 1, -- Chỉ chứa 1 (Hiện) hoặc 0 (Ẩn)
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- ========================================================
-- TẠO CÁC INDEX DƯ THỪA (Tình trạng trước khi tối ưu)
-- ========================================================
CREATE INDEX idx_user_id ON Posts(user_id);
CREATE INDEX idx_content ON Posts(content(255)); 
CREATE INDEX idx_post_type ON Posts(post_type); 
CREATE INDEX idx_is_visible ON Posts(is_visible); 
CREATE INDEX idx_created_at ON Posts(created_at);

-- ========================================================
-- THÊM DỮ LIỆU MẪU (Để truy vấn kiểm tra dung lượng có kết quả)
-- ========================================================
INSERT INTO Posts (user_id, content, post_type, is_visible) VALUES
(1, 'Hôm nay trời đẹp quá, đi code thôi!', 'TEXT', 1),
(2, 'Cảnh hoàng hôn tuyệt đẹp', 'IMAGE', 1),
(1, 'Hướng dẫn tối ưu MySQL cơ bản', 'VIDEO', 1),
(3, 'Bài viết này vi phạm tiêu chuẩn cộng đồng nên bị ẩn', 'TEXT', 0),
(4, 'Lạm dụng Index làm chậm tốc độ ghi (Write) của Database...', 'TEXT', 1);
import sqlite3

def init_db():
    conn = sqlite3.connect('game_data.db')
    # cursor = conn.cursor()


# ----------------------------
# def delete_all():
#     conn = sqlite3.connect('game_data.db')
#     cursor = conn.cursor()
#     conn.commit()
#     conn.close()
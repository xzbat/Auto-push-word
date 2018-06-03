# -*- coding: utf-8 -*-
import xdrlib
import sys
import xlrd
import time
import os
import xlwt

# open the xls file


def open_excel(file='words-book/xls/fojiao.xls'):
    try:
        data = xlrd.open_workbook(file)
        return data
    except Exception as e:
        print (str(e))

# read the words


def read_excel():
    data = open_excel()
    tableDisordered = data.sheets()[0]
    nrows = tableDisordered.nrows
    colnames = tableDisordered.row_values(0)
    list = []
    for rownum in range(0, nrows):
        row = tableDisordered.row_values(rownum)
        if row:
            app = []
            for i in range(len(colnames)):
                app.append(row[i])
            list.append(app)
    return list

# write words into README.md
# You can set how many words you want to recite everyday


def write_words(tables, wordNum=30):
    script_dir = os.path.dirname(os.path.realpath('__file__'))
    today = time.strftime("%Y-%m-%d")
    todayFileName = today + ".md"
    today_file_path = os.path.join(script_dir, "days/" + todayFileName)
    readme = open(script_dir + '/days/README.md', 'a', encoding='utf-8')
    todayFile = open(today_file_path, 'a', encoding='utf-8')
    # print (today_file_path)
    count = 0
    while count < wordNum:
        row = tables[count]
        word = row[0]
        characteristic = row[1]
        discription = row[2]
        todayFile.write('| %s | %s | %s |\n' % (word, characteristic, discription))
        print (word,characteristic,discription)
        count = count + 1
        pass

    print (len(tables))
    count_rest = count;
    wbk = xlwt.Workbook()
    sheet = wbk.add_sheet('disordered')
    while count_rest < len(tables):
        print (count_rest)
        row = tables[count_rest]
        word = row[0]
        characteristic = row[1]
        discription = row[2]
        sheet.write(count_rest - wordNum, 0, word)
        sheet.write(count_rest - wordNum, 1, characteristic)
        sheet.write(count_rest - wordNum, 2, discription)
        count_rest = count_rest + 1
        pass
    wbk.save('words-book/xls/fojiao.xls')

    # writer = pd.ExcelWriter('words-book/xls/fojiao.xlsx')

    # for row in tables:
    #     word = row[0]
    #     characteristic = row[1]
    #     discription = row[2]
    #     todayFile.write('| %s | %s | %s |\n' % ("word", "characteristic", "discription"))
    #     print (word,characteristic,discription)

def tests():

    return

def main():
    tables = read_excel()
    write_words(tables)
    # tests()

if __name__ == "__main__":
    main()

require 'byebug'

class Sudoku
	attr_accessor :board

	def initialize(data)
		self.board = SudokuBoard.new(data)
	end

	def solve
		values = board.get_all_available_values
	end
end

class SudokuBoard
	attr_accessor :data

#X4XX1X5XXXX54X28XX6XXXXXXX9X5X7XXXX18XX9XX6XXXX2XX54XXXX4XXX9XX5X18X63XXXXX2XXX6X
	def initialize(_data)
		self.data = _data.scan(/.{9}/)
	end

	def get_all_available_values
		res = []
		hash = {}
		row=0
		col=0

		while row <= 8
			tmp = []
			while col <= 8
				num = get_available_values(row, col)
				tmp << num
				hash[num.count] ||= Array.new
				hash[num.count] << [row, col, num]
				col += 1
			end
			res << tmp
			tmp = []
			row += 1
		end

		hash = Hash[hash.sort_by{|k,v| k}]
		return res, hash
	end

	def get_available_values(row, col)
		used_values = get_elements_in_sub_board(get_sub_board(row, col)).split("")
		used_values += get_column(col)
		used_values += get_row(row).split("")

		available = (1..9).to_a - used_values.uniq.map(&:to_i).reject{|x| x.zero?}
		return available
	end

	def get_sub_board(row, col)
		factor = (row/3.0).floor
		pos    = (col/3.0).floor

		return (3*factor)+pos
	end

	def get_elements_in_sub_board(n)
		case n
			when 0
				return self.data[0][0..2] + self.data[1][0..2] + self.data[2][0..2]
			when 1
				return self.data[0][3..5] + self.data[1][3..5] + self.data[2][3..5]
			when 2
				return self.data[0][6..8] + self.data[1][6..8] + self.data[2][6..8]

			when 3
				return self.data[3][0..2] + self.data[4][0..2] + self.data[5][0..2]
			when 4
				return self.data[3][3..5] + self.data[4][3..5] + self.data[5][3..5]
			when 5
				return self.data[3][6..8] + self.data[4][6..8] + self.data[5][6..8]

			when 6
				return self.data[6][0..2] + self.data[7][0..2] + self.data[8][0..2]
			when 7
				return self.data[6][3..5] + self.data[7][3..5] + self.data[8][3..5]
			when 8
				return self.data[6][6..8] + self.data[7][6..8] + self.data[8][6..8]
		end
	end

	def get_column(col)
		self.data.map{|x| x[col]}
	end

	def get_row(row)
		self.data[row]
	end
end

def main
	sudoku = Sudoku.new("X4XX1X5XXXX54X28XX6XXXXXXX9X5X7XXXX18XX9XX6XXXX2XX54XXXX4XXX9XX5X18X63XXXXX2XXX6X")

	puts sudoku.board.get_all_available_values
end

main()
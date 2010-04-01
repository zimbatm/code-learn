
def hash_to_arr(h)
	arr = []
	while h.kind_of?(Hash)
		# FIXME : check h.size ?
		k = h.keys[0]
		arr.push(k)
		h = h[k]
	end
	arr.push h
end

puts hash_to_arr(:club).join('.')
puts hash_to_arr(:club => :title).join('.')
puts hash_to_arr(:user => {:club => :title}).join('.')
puts hash_to_arr(:user => {:club => {:owners => :name}}).join('.')

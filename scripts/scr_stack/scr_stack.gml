function ds_list_top(index) {
	return index[|ds_list_size(index) - 1];
}

function ds_list_pop(index) {
	var temp = index[|ds_list_size(index) - 1];
	ds_list_delete(index, ds_list_size(index) - 1);
	return temp;
}
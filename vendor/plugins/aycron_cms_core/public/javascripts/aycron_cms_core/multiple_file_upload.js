// -------------------------
// Multiple File Upload
// -------------------------
function MultiSelector(list_target, max, association, current_number, sorted){
    this.list_target = list_target;
    this.count = current_number;
    this.id = 0;
    this.association = association;
	this.sorted = sorted;
    if (max) {
        this.max = max;
    }
    else {
        this.max = -1;
    };
    
    this.addElement = function(element){
        if (element.tagName == 'INPUT' && element.type == 'file') {
            element.name = association + '[file_' + (this.id) + ']';
            element.id = association + '_file_' + (this.id);
			this.id++;
            element.multi_selector = this;
            element.onchange = function(){
                var new_element = document.createElement('input');
                new_element.type = 'file';
                this.parentNode.insertBefore(new_element, this);
                this.multi_selector.addElement(new_element);
                this.multi_selector.addListRow(this);
                this.style.position = 'absolute';
                this.style.left = '-1000px';
            };
            if (this.max != -1 && this.count >= this.max) {
                element.disabled = true;
            };
            this.count++;
            this.current_element = element;
        }
        else {
            alert('Error: not a file input element');
        };
    };
    
    this.addListRow = function(element){
        var new_row = document.createElement('li');
        new_row.id = "li_" + association + "_file_" + (this.id-2);
		
        // create sorting buttons
        if (this.sorted) {
			var new_row_pos = document.createElement('input');
			new_row_pos.type = 'text';
			new_row_pos.value = get_max_pos(this.list_target) + 1;
			new_row_pos.id = association + "_pos_file_" + (this.id - 2);
			new_row_pos.name = association + "[pos_file_" + (this.id - 2) + "]";
			new_row_pos.style.position = 'absolute';
			new_row_pos.style.left = '-1000px';
			new_row.appendChild(new_row_pos);
			var new_row_button = document.createElement('a');
			new_row_button.title = 'Up';
			new_row_button.href = '#';
			new_row_button.innerHTML = 'Up';
			new_row_button.onclick = function(){
				return file_up(this);
			};
			new_row.appendChild(new_row_button);
			var new_row_button = document.createElement('a');
			new_row_button.title = 'Down';
			new_row_button.href = '#';
			new_row_button.innerHTML = 'Down';
			new_row_button.onclick = function(){
				return file_down(this);
			};
			new_row.appendChild(new_row_button);
		}
        
        // show filename
        var new_row_filename = document.createElement('span');
        new_row_filename.innerHTML = element.value.split('/')[element.value.split('/').length - 1];
        new_row.appendChild(new_row_filename);
        
        // create remove button
        var new_row_button = document.createElement('a');
        new_row_button.title = 'Remove This Image';
        new_row_button.href = '#';
        new_row_button.innerHTML = 'Remove';
        new_row.element = element;
        new_row_button.onclick = function(){
			return file_remove(this, true);
        };
        new_row.appendChild(new_row_button);
        
        // add li to html
        this.list_target.appendChild(new_row);
    };
}

function file_remove(element, new_attachment) {
    var li_attachment = element.parentNode;
    var next_li_attachment = get_next_attachment(li_attachment);
	var current_pos = get_position(li_attachment);
	// make input enabled
	var nodes = li_attachment.parentNode.parentNode.childNodes;
	for (var i=0; i < nodes.length; i++) {
        if (nodes[i].tagName == 'INPUT' && nodes[i].type == 'file') {
			nodes[i].disabled = false;
			break;			
		}
	}
	// update positions
	while (next_li_attachment != null) {
		set_position(next_li_attachment, current_pos);
		next_li_attachment = get_next_attachment(next_li_attachment);
		current_pos++;
	}
	if (new_attachment) {
		input_id = li_attachment.id.substr(3);
		input_attachment = document.getElementById(input_id);
		input_attachment.parentNode.removeChild(input_attachment);
		li_attachment.parentNode.removeChild(li_attachment);
	} else {
		li_attachment.parentNode.parentNode.parentNode.appendChild(li_attachment);
		set_position(li_attachment, -1);
        li_attachment.style.position = 'absolute';
        li_attachment.style.left = '-1000px';
	}
	return false;
}

function file_up(element){
    var li_attachment = element.parentNode;
    var prev_li_attachment = get_prev_attachment(li_attachment);
    if (prev_li_attachment != null) {
        var li_parent = li_attachment.parentNode;
        li_parent.removeChild(li_attachment);
        li_parent.insertBefore(li_attachment, prev_li_attachment);
		// change order
		var old_position = get_position(li_attachment);
		var new_position = get_position(prev_li_attachment);
		set_position(li_attachment, new_position);
		set_position(prev_li_attachment, old_position);
    }
    return false;
}

function file_down(element){
    var li_attachment = element.parentNode;
    var next_li_attachment = get_next_attachment(li_attachment);
    if (next_li_attachment != null) {
        var li_parent = li_attachment.parentNode;
        li_parent.removeChild(next_li_attachment);
        li_parent.insertBefore(next_li_attachment, li_attachment);
		// change order
		var old_position = get_position(li_attachment);
		var new_position = get_position(next_li_attachment);
		set_position(li_attachment, new_position);
		set_position(next_li_attachment, old_position);
    }
    return false;
}

function get_max_pos(container) {
	var max_pos = 0;
	var nodes = container.childNodes;
	for (var i=0; i<nodes.length; i++) {
		if (nodes[i].nodeName == "LI")
			max_pos++;
	}
	return max_pos;
}

function get_position(li_attachment) {
	var nodes = li_attachment.childNodes;
	for (var i=0; i<nodes.length; i++) {
		if (nodes[i].nodeName == "INPUT")
			return parseInt(nodes[i].value);
	}
	return null;
}

function set_position(li_attachment, position) {
	var nodes = li_attachment.childNodes;
	for (var i=0; i<nodes.length; i++) {
		if (nodes[i].nodeName == "INPUT") {
			nodes[i].value = position;
			break;
		}
	}
}

function get_next_attachment(li_attachment) {
    var next_li_attachment = li_attachment.nextSibling;
	while (next_li_attachment != null && next_li_attachment.nodeName != "LI") {
		next_li_attachment = next_li_attachment.nextSibling;
	}
	return next_li_attachment;
}

function get_prev_attachment(li_attachment) {
    var prev_li_attachment = li_attachment.previousSibling;
	while (prev_li_attachment != null && prev_li_attachment.nodeName != "LI") {
		prev_li_attachment = prev_li_attachment.previousSibling;
	}
	return prev_li_attachment;
}

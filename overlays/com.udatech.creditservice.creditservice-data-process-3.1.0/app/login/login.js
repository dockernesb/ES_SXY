var Login = function() {

	var handleLogin = function() {
		$('.login-form').validate({
			errorElement : 'span', // default input error message container
			errorClass : 'help-block', // default input error message class
			focusInvalid : false, // do not focus the last invalid input
			rules : {
				username : {
					required : true
				},
				password : {
					required : true
				},
				verCode : {
					required : true
				}
			},

			invalidHandler : function(event, validator) { // display error
				// alert on form
				// submit
				$('.alert-danger', $('.login-form')).show();
			},

			highlight : function(element) { // hightlight error inputs
				$(element).closest('.form-group').addClass('has-error');
			},

			success : function(label) {
				label.closest('.form-group').removeClass('has-error');
				label.remove();
			},

			errorPlacement : function(error, element) {
				error.insertAfter(element.closest('.input-icon'));
			},

			submitHandler : function(form) {
				form.submit();
			}
		});

		$('.login-form input').keypress(function(e) {
			if (e.which == 13) {
				submitForm();
			}
		});
	}

	function submitForm() {
		if ($('.login-form').validate().form()) {
			loginForm.submit();
		}
	}

	return {
		// main function to initiate the module
		init : function() {
			handleLogin();
		},
		submitForm : submitForm
	};
}();
var common = {
    submitCreatingForm: function(path, method, target, params)
    {
        if ( params == null ) {
            return;
        }

        var form = document.createElement('form');
        document.body.appendChild(form);
        form.setAttribute('action', path);
        form.setAttribute('method', method);
        form.setAttribute('target', target);

        for ( var key in params ) {
            var input = document.createElement('input');
            input.setAttribute('type',  'hidden');
            input.setAttribute('name',  key);
            input.setAttribute('value', params[key]);
            form.appendChild(input);
        }

        form.submit();
    }
};

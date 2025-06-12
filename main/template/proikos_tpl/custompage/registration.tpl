<script src="https://www.google.com/recaptcha/enterprise.js?render=6LdtBDcrAAAAAAhENW2wEv233wvPb6TOcrZ4p4ya"></script>
<div class="custompage">
    <div class="limiter">
        <div class="container-login">
            <div class="wrap-login width-register">
                <div class="logo-register">
                    {% if picture %}
                        <div class="row">
                            <div class="col-md-6">
                                <a href="{{ _p.web }}">
                                    <img width="250px" title="{{ _s.site_name }}" src="{{ _p.web_css_theme }}images/logo.svg">
                                </a>
                            </div>
                            <div class="col-md-6">
                                <a href="{{ _p.web }}">
                                    <img width="150px" title="{{ _s.site_name }}" src="{{ picture }}">
                                </a>
                            </div>
                        </div>
                    {% else %}
                        <a href="{{ _p.web }}">
                            <img width="250px" title="{{ _s.site_name }}" src="{{ _p.web_css_theme }}images/logo.svg">
                        </a>
                    {% endif %}
                </div>
                <h3 class="title">{{ title }}</h3>

                {{ form }}

                <div class="software-name">
                    <a href="{{_p.web}}" target="_blank">
                        {{ "PoweredByX" |get_lang | format(_s.software_name) }}
                    </a>&copy; {{ "now"|date("Y") }}
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    let urlAjax = '{{ url_plugin }}/src/ajax.php';

    $(document).ready(function() {
        $('#validate_code').click(function() {
            // Obtener los valores del campo de texto y el select
            var companyCode = $('#registration-two_company_code').val(); // Valor del código de empresa
            var idCompany = $('#registration-two_contrating_companies').val(); // Valor de la empresa seleccionada

            // Verificar si ambos campos no están vacíos
            if (companyCode.trim() === "" || idCompany.trim() === "") {
                $('#validation_message').removeClass('alert-success').addClass('alert-danger');
                $('#validation_message').text('Please fill in both fields.');
                $('#validation_message').show();
                return; // Detener la ejecución si falta información
            }

            // Realizar la solicitud AJAX
            $.ajax({
                url: urlAjax + '?action=validate_company_code',
                type: 'POST',
                data: {
                    company_code: companyCode,
                    id_company: idCompany
                },
                dataType: 'json', // Esperamos un JSON como respuesta
                success: function(response) {
                    if (response.success) {
                        // Si la validación es exitosa
                        $('#validation_message').removeClass('alert-danger').addClass('alert-success');
                        $('#validation_message').text(response.message); // Mostrar el mensaje de éxito
                        $('.terms_conditions_container').show();
                    } else {
                        // Si la validación falla
                        $('#validation_message').removeClass('alert-success').addClass('alert-danger');
                        $('#validation_message').text(response.message); // Mostrar el mensaje de error
                    }
                    $('#validation_message').show(); // Mostrar el mensaje
                },
                error: function() {
                    $('#validation_message').removeClass('alert-success').addClass('alert-danger');
                    $('#validation_message').text('There was an error with the request.');
                    $('#validation_message').show(); // Mostrar mensaje de error si hay un problema con la solicitud
                }
            });
        });
    });


    $("#registration-two_stakeholders").change(function (){
        let idSelector = $("#registration-two_stakeholders").val();
        console.log(idSelector);
        if(idSelector == 1 ){
            $('#option-builder').hide();
            $('#option-number').show();
            $('.terms_conditions_container').show();
        } else {
            $('#option-builder').show();
            $('#option-number').hide();
            $('.terms_conditions_container').hide();
        }
        $.ajax({
            url: urlAjax + "?action=get_position&id_stakeholders=" + idSelector,
            type: 'post',
            dataType: 'json',
            success: function (response){
                let item = "";
                $.each(response, function(index, value){
                    //console.log(index + '----'+ value);
                    item+='<option value="'+index+'">'+value+'</option>';
                });
                //item+='<option value="999">Otros</option>';
                $('#registration-two_position_company').html(item);
                $('#registration-two_position_company').selectpicker('refresh');
            },
            error: function (){
                alert("error")
            }
        });
    });

    /*$("#registration-two_name_company").change(function (){
        let idSelector = $("#registration-two_name_company").val();
        //console.log(idSelector);
        $.ajax({
            url: urlAjax + "?action=get_administrator&id_company=" + idSelector,
            type: 'post',
            dataType: 'json',
            success: function (response){
                let item = response;
                //console.log(response);
                $('#registration-two_contact_manager').val(item);
            },
            error: function (){
                alert("error")
            }
        });
    });*/

    $("#registration-two_area").change(function (){
        let idSelector = $("#registration-two_area").val();
        console.log(idSelector);
        $.ajax({
            url: urlAjax + "?action=get_management&id_area=" + idSelector,
            type: 'post',
            dataType: 'json',
            success: function (response){
                let item = "";
                $.each(response, function(index, value){
                    //console.log(index + '----'+ value);
                    item+='<option value="'+index+'">'+value+'</option>';
                });
                //item+='<option value="999">Otros</option>';
                $('#registration-two_department').html(item);
                $('#registration-two_department').selectpicker('refresh');
            },
            error: function (){
                alert("error")
            }
        });
    });

    $("#registration-two_department").change(function (){
        let idSelector = $("#registration-two_department").val();
        console.log(idSelector);
        $.ajax({
            url: urlAjax + "?action=get_headquarters&id_management=" + idSelector,
            type: 'post',
            dataType: 'json',
            success: function (response){
                let item = "";
                $.each(response, function(index, value){
                    //console.log(index + '----'+ value);
                    item+='<option value="'+index+'">'+value+'</option>';
                });
                //item+='<option value="999">Otros</option>';
                $('#registration-two_headquarters').html(item);
                $('#registration-two_headquarters').selectpicker('refresh');
            },
            error: function (){
                alert("error")
            }
        });
    });

    $(document).ready(function() {
        $('#registration-two_stakeholders').prop('required', true);
        $('#registration-two_position_company').prop('required', true);
        $('#registration-two_area').prop('required', true);
        $('#registration-two_department').prop('required', true);
        $('#registration-two_headquarters').prop('required', true);
    });

    const rucCompany = document.querySelector('input[name="ruc_company"]');
    const searchCompanyByRuc = function (ruc) {
        let urlCampus = '{{_p.web}}';
        let urlGetCompanyByRuc = urlCampus + 'plugin/proikos/src/ajax.php?action=get_company_by_ruc';

        $.ajax({
            type: 'POST',
            url: urlGetCompanyByRuc,
            data: { ruc },
            dataType: 'json',
            success: function(response) {
                const { name_company } = response;
                document.querySelector('input[name="name_company"]').value = (name_company ?? '');
                document.querySelector('input[name="name_company"]').readOnly = !!name_company;
            },
            error: function(jqXHR, textStatus, errorThrown) {
                console.log("Error: " + errorThrown);
            }
        });
    }

    if (rucCompany) {
        let typingTimer = null;
        const doneTypingInterval = 500;

        rucCompany.addEventListener('input', function () {
            // only numbers
            this.value = this.value.replace(/[^0-9]/g, '');

            if (typingTimer) {
                clearTimeout(typingTimer);
            }

            const ruc = this.value?.trim();

            if (ruc.length >= 11) {
                typingTimer = setTimeout(function() {
                    searchCompanyByRuc(ruc);
                }, doneTypingInterval);
            }
        });
    }

</script>
<script>
    function onClick(e) {
        e.preventDefault();
        grecaptcha.enterprise.ready(async () => {
            const token = await grecaptcha.enterprise.execute('6LdtBDcrAAAAAAhENW2wEv233wvPb6TOcrZ4p4ya', {action: 'LOGIN'});
        });
    }
</script>

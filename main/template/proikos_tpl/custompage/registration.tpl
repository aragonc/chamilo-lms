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
    $("#registration-two_stakeholders").change(function (){
        let idSelector = $("#registration-two_stakeholders").val();
        console.log(idSelector);
        if(idSelector == 1 ){
            $('#option-builder').hide();
            $('#option-number').show();
        } else {
            $('#option-builder').show();
            $('#option-number').hide();
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

</script>
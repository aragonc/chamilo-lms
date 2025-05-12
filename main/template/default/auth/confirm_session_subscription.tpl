<div>
    {% for cert in request_certificates %}
    <div style="margin-bottom: 14px;">
        <label class="form-label">{{ cert.name }}</label>
        <div class="input-group col-sm-12">
            <input type="file" class="form-control d-none" id="file_{{ cert.id }}" name="certificate_{{ cert.id }}" style="border-radius: 4px;">
        </div>
    </div>
    {% endfor %}
</div>

<div class="row">
    <div class="col-sm-3 col-sm-offset-3">
        <button data-href="{{ _p.web_main }}auth/courses.php?{{ {'action':'subscribe_to_session', 'session_id':session_id, 'confirm':'1'}|url_encode() }}"
           class="btn btn-success btn-block disabled" id="yesBtn">
            {{ 'Yes'|get_lang }}
        </button>
    </div>
    <div class="col-sm-3">
        <button type="button" class="btn btn-danger btn-block" data-dismiss="modal">{{ 'No'|get_lang }}</button>
    </div>
</div>

<script>
    const inputs = document.querySelectorAll('input[type="file"]');
    const yesBtn = document.getElementById('yesBtn');
    const total = yesBtn ? inputs.length : 0;
    const formUploadAction = '{{ _p.web_plugin }}proikos/src/ajax.php?action=upload_user_certificates&session_id={{ session_id }}';

    function updateStatus() {
        if (yesBtn === null) {
            return;
        }

        let filled = 0;
        inputs.forEach(input => {
            if (input.files.length > 0) {
                filled++;
            }
        });
        if (filled === total) {
            yesBtn.classList.remove('disabled');
            yesBtn.removeAttribute('disabled');
        } else {
            yesBtn.classList.add('disabled');
            yesBtn.setAttribute('disabled', 'disabled');
        }
    }

    inputs.forEach(input => {
        input.addEventListener('change', function () {
            updateStatus();
        });
    });

    updateStatus();

    yesBtn.addEventListener('click', function (e) {
        e.preventDefault();
        const href = yesBtn.getAttribute('data-href');
        const formData = new FormData();
        inputs.forEach(input => {
            if (input.files.length > 0) {
                formData.append(input.name, input.files[0]);
            }
        });


        fetch(formUploadAction, {
            method: 'POST',
            body: formData
        })
        .then(response => {
            console.log('response', response);
        })
        .catch(error => {
            console.error('Error:', error);
        })
        .finally(() => {
            window.location = href;
        });
    });
</script>



<style>
    [type="file"] {
        /* Style the color of the message that says 'No file chosen' */
        color: #878787;
    }
    [type="file"]::-webkit-file-upload-button {
        background: var(--primary-color);
        border: 2px solid var(--primary-color);
        border-radius: 4px;
        color: #fff;
        cursor: pointer;
        font-size: 12px;
        outline: none;
        text-transform: uppercase;
        transition: all 1s ease;
    }

    [type="file"]:disabled::-webkit-file-upload-button {
        background: #878787;
        border: 2px solid #878787;
        color: #fff;
    }
</style>

<div style="margin-bottom: 40px;">
    {% if request_certificates %}
        <span class="title">{{ 'Para poder inscribirte adjunta tu certificado de Inducción e IPERC vigentes:' }}</span>

        {% for cert in request_certificates %}
        <div style="margin-bottom: 14px;">
            <label class="form-label">{{ cert.name }}</label>
            <div class="input-group col-sm-12">
                <input type="file" class="form-control d-none" id="file_{{ cert.id }}"
                       name="certificate_{{ cert.id }}" style="border-radius: 4px;" value="{{ cert.id }}">
            </div>
        </div>
        {% endfor %}
    {% endif %}
</div>

<div>
    {% if optional_request_certificates %}
        <span class="title">{{ 'Para poder inscribirte adjunta tus certificados de Alto Riesgo:' }}</span>

        {% for cert in optional_request_certificates %}
        <div style="margin-bottom: 14px;">
            <input type="checkbox" class="form-check-input" id="cert_{{ cert.id }}" name="cert_{{ cert.id }}" value="{{ cert.id }}">
            <label class="form-label" for="cert_{{ cert.id }}">{{ cert.name }}</label>
            <div class="input-group col-sm-12">
                <input type="file" disabled class="form-control d-none" id="optional_cert_{{ cert.id }}" name="optional_certificate_{{ cert.id }}" style="border-radius: 4px;">
            </div>
        </div>
        {% endfor %}
    {% endif %}
</div>

<div class="row">
    <div class="col-sm-3 col-sm-offset-3">
        <button data-href="{{ _p.web_main }}auth/courses.php?{{ {'action':'subscribe_to_session', 'session_id':session_id, 'confirm':'1'}|url_encode() }}"
           class="btn btn-success btn-block" id="yesBtn">
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
            //yesBtn.classList.remove('disabled');
            //yesBtn.removeAttribute('disabled');
        } else {
            //yesBtn.classList.add('disabled');
            //yesBtn.setAttribute('disabled', 'disabled');
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

        if (inputs && inputs.length) {
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
        } else {
            window.location = href;
        }
    });

    // select all checkboxes and enable file inputs
    const checkboxes = document.querySelectorAll('input[type="checkbox"]');
    if (checkboxes.length > 0) {
        checkboxes.forEach(checkbox => {
            checkbox.addEventListener('change', function () {
                const fileInput = document.getElementById('optional_cert_' + this.value);
                if (this.checked) {
                    fileInput.removeAttribute('disabled');
                    fileInput.classList.remove('d-none');
                } else {
                    fileInput.setAttribute('disabled', 'disabled');
                    fileInput.classList.add('d-none');
                }
            });
        });
    }
</script>



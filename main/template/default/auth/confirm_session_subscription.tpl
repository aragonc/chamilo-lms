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

    .required-text {
        color: red;
    }

    .input-cert-title {
        text-transform: uppercase;
    }
</style>

    {% if request_certificates %}
    <div style="margin-bottom: 40px;">
        <span class="title">
            <small class="required-text">*</small>
            {{ 'Adjuntar los siguientes certificados vigentes:' }}
        </span>

        {% for cert in request_certificates %}
        <div style="margin-bottom: 14px;">
            <label class="form-label input-cert-title">{{ cert.name }}</label>
            <div class="input-group col-sm-12">
                <input type="file" accept="application/pdf" class="form-control d-none cert-required" id="file_{{ cert.id }}"
                       name="certificate_{{ cert.id }}" style="border-radius: 4px;" value="{{ cert.id }}">
            </div>
        </div>
        {% endfor %}
    </div>
    {% endif %}

    {% if optional_request_certificates %}
    <div>
        <span class="title">{{ '(Opcional) Adjuntar los siguientes certificados vigentes:' }}</span>

        {% for cert in optional_request_certificates %}
        <div style="margin-bottom: 14px;">
            <input type="checkbox" class="form-check-input" id="cert_{{ cert.id }}" name="cert_{{ cert.id }}" value="{{ cert.id }}">
            <label class="form-label input-cert-title" for="cert_{{ cert.id }}">{{ cert.name }}</label>
            <div class="input-group col-sm-12">
                <input type="file" accept="application/pdf" disabled class="form-control d-none" id="optional_cert_{{ cert.id }}" name="optional_certificate_{{ cert.id }}" style="border-radius: 4px;">
            </div>
        </div>
        {% endfor %}
    </div>
    {% endif %}

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
    const inputsRequired = document.querySelectorAll('input[type="file"].cert-required');
    const yesBtn = document.getElementById('yesBtn');
    const total = yesBtn ? inputsRequired.length : 0;
    const formUploadAction = '{{ _p.web_plugin }}proikos/src/ajax.php?action=upload_user_certificates&session_id={{ session_id }}';

    function updateStatus() {
        if (yesBtn === null) {
            return;
        }

        let filled = 0;
        inputsRequired.forEach(input => {
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

    if (inputs) {
        inputs.forEach(input => {
            input.addEventListener('change', function () {
                const file = this.files[0];
                if (!file) return;

                if (file.type !== 'application/pdf') {
                    alert('Solo se permiten archivos PDF.');
                    this.value = '';
                    return;
                }

                const maxSizeInBytes = 10 * 1024 * 1024; // 10 MB
                if (file.size > maxSizeInBytes) {
                    alert('El archivo excede el tamaño máximo de 10 MB.');
                    this.value = '';
                    return;
                }

                updateStatus();
            });
        });
    }

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

            yesBtn.setAttribute('disabled', 'disabled');
            fetch(formUploadAction, {
                method: 'POST',
                body: formData
            })
            .then(response => {
                console.log('response', response);
            })
            .catch(error => {
                console.error('Error:', error);
                yesBtn.removeAttribute('disabled');
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



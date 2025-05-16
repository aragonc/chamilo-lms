
<h3>Hola!,{{ complete_name }}</h3>

<p>Te queremos dar la más cordial bienvenida a tu aula virtual.</p>
<p>Tus datos de acceso son los siguientes:</p>

<div style="background: #F5EED0; padding: 10px 20px;">
    <p><strong>URL de acceso</strong>: <a href="{{ _p.web }}">{{ _p.web }}</a><br>
    <strong>{{ 'Username'|get_lang }} :</strong> {{ login_name }}<br>
        <strong> {{ 'Pass'|get_lang }} :</strong> {{ original_password }}</p>
</div>

<p>Te recordamos cambiar la contraseña de tu inicio de sesión.
    Cualquier duda técnica nos puedes escribir al email <strong>academy@proikos.pe</strong>
</p>

<style>
    .table-container {
        max-width: 900px;
        margin: auto;
        background-color: #fff;
        border-radius: 8px;
        overflow: hidden;
        box-shadow: 0 4px 8px rgba(0,0,0,0.1);
    }

    .table-container h2 {
        text-align: center;
        color: #004085;
        margin-top: 20px;
    }

    .table-container table {
        width: 100%;
        border-collapse: collapse;
        background-color: #fcf8e3;
    }

    .table-container th, td {
        padding: 15px;
        text-align: left;
        border-bottom: 1px solid #dee2e6;
        vertical-align: top;
    }

    .table-container th {
        background-color: #f7ecb5;
        color: #212529;
        font-weight: bold;
    }

    .table-container tr:hover {
        background-color: #f1f3f5;
    }

    .table-container .info {
        color: #495057;
    }
</style>
<div class="table-container">
    <h2>Tabla N° 1: Mensaje Informativo - Cursos CASS</h2>
    <table>
        <thead>
        <tr>
            <th style="border-right: 1px solid #969a9d; border-bottom: 1px solid #969a9d;">Nombre del Curso</th>
            <th style="border-bottom: 1px solid #969a9d;">Mensaje Informativo</th>
        </tr>
        </thead>
        <tbody>
        <tr>
            <td style="border-right: 1px solid #969a9d; border-bottom: 1px solid #969a9d;">Inducción CASS</td>
            <td style="border-bottom: 1px solid #969a9d;" class="info">
                Todo personal nuevo (propio y contratista) antes de la ejecución de sus actividades, debe recibir la Inducción CASS (8 horas).
                La validez de la inducción es de dos (2) años, con la debida anticipación deberá llevarlo nuevamente para su renovación.
            </td>
        </tr>
        <tr>
            <td style="border-right: 1px solid #969a9d; border-bottom: 1px solid #969a9d;">Matriz IPERC / ATS</td>
            <td style="border-bottom: 1px solid #969a9d;" class="info">
                El usuario debe tener Inducción CASS aprobada y vigente (nota aprobatoria de 14) el cual será validado posteriormente.
                Caso contrario el usuario saldrá desaprobado del curso.
            </td>
        </tr>
        <tr>
            <td style="border-right: 1px solid #969a9d;">Permisos de Trabajo</td>
            <td class="info">
                El personal debe tener previamente:<br>
                • Los cursos de Inducción CASS e IPERC / ATS aprobados y vigentes (nota aprobatoria de 14).<br>
                • Certificado en el trabajo de alto riesgo que ejecutará, aplicable para personal contratistas.<br>
                Los mismos serán validados, caso contrario el personal saldrá desaprobado del curso.
            </td>
        </tr>
        </tbody>
    </table>
</div>

<p style="color: #EF7C00; font-weight: bold; font-size: 18px; text-align: center;">Saludos. Equipo online</p>

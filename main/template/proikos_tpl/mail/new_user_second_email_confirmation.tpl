<p>{{ 'Dear'|get_lang }} {{ complete_name }},</p>
<p>{{ 'YouAreReg'|get_lang }} {{ _s.site_name }} {{ 'WithTheFollowingSettings'|get_lang }}</p>
    {{ 'Pass'|get_lang }} : {{ original_password }}</p>
<p>{{ 'YouReceivedAnEmailWithTheUsername'|get_lang }}</p>
<p>{{ 'ThanksForRegisteringToSite'|get_lang|format(_s.site_name) }}</p>
<p>{{ 'Address'|get_lang }} {{ _s.site_name }} {{ 'Is'|get_lang }} : {{ mailWebPath }}</p>
<p>{{ 'Problem'|get_lang }}</p>
<p>{{ 'SignatureFormula'|get_lang }}</p>
<p>{{ _admin.name }}, {{ _admin.surname }}<br>
    {{ 'Manager'|get_lang }} {{ _s.site_name }}<br>
    {{ _admin.telephone ? 'T. ' ~ _admin.telephone }}<br>
    {{ _admin.email ? 'Email'|get_lang ~ ': ' ~ _admin.email }}</p>

<style>
    body {
        font-family: Arial, sans-serif;
        background-color: #f8f9fa;
        color: #333;
        padding: 20px;
    }

    .table-container {
        max-width: 900px;
        margin: auto;
        background-color: #fff;
        border-radius: 8px;
        overflow: hidden;
        box-shadow: 0 4px 8px rgba(0,0,0,0.1);
    }

    h2 {
        text-align: center;
        color: #004085;
        margin-top: 20px;
    }

    table {
        width: 100%;
        border-collapse: collapse;
        background-color: #fcf8e3;
    }

    th, td {
        padding: 15px;
        text-align: left;
        border-bottom: 1px solid #dee2e6;
        vertical-align: top;
    }

    th {
        background-color: #f7ecb5;
        color: #212529;
        font-weight: bold;
    }

    tr:hover {
        background-color: #f1f3f5;
    }

    .info {
        color: #495057;
    }
</style>
<div class="table-container">
    <h2>Tabla N° 1: Mensaje Informativo - Cursos CASS</h2>
    <table>
        <thead>
        <tr>
            <th>Nombre del Curso</th>
            <th>Mensaje Informativo</th>
        </tr>
        </thead>
        <tbody>
        <tr>
            <td>Inducción CASS</td>
            <td class="info">
                Todo personal nuevo (propio y contratista) antes de la ejecución de sus actividades, debe recibir la Inducción CASS (8 horas).
                La validez de la inducción es de dos (2) años, con la debida anticipación deberá llevarlo nuevamente para su renovación.
            </td>
        </tr>
        <tr>
            <td>Matriz IPERC / ATS</td>
            <td class="info">
                El usuario debe tener Inducción CASS aprobada y vigente (nota aprobatoria de 14) el cual será validado posteriormente.
                Caso contrario el usuario saldrá desaprobado del curso.
            </td>
        </tr>
        <tr>
            <td>Permisos de Trabajo</td>
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

    </div>
    </section>
    <!-- END CONTENT -->

    {% if show_footer == true %}
    <!-- START FOOTER -->
    <footer class="footer">
        {% include 'layout/page_footer.tpl'|get_template %}
    </footer>
    <!-- END FOOTER -->
    {% endif %}

    </main>
    <!-- END MAIN -->

    {% include 'layout/modals.tpl'|get_template %}

    <!-- Modal para Registrar Incidencia -->
    <div class="modal fade" id="modalIncidencia" tabindex="-1" role="dialog" aria-labelledby="modalIncidenciaLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
                <div class="modal-header bg-primary text-white">
                    <h5 class="modal-title" id="modalIncidenciaLabel">Registrar Incidencia del Alumno</h5>
                    <button type="button" class="close text-white" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <form id="formIncidencia">
                        <!-- Información del usuario -->
                        <div class="alert alert-info">
                            <strong>Estudiante:</strong> <span id="userNameDisplay">-</span> |
                            <strong>Usuario ID:</strong> <span id="userIdDisplay">-</span>
                        </div>

                        <!-- Select múltiple de sustentos/incidencias -->
                        <div class="form-group">
                            <label for="sustenance_select"><strong>Tipo de Incidencia (selecciona una o más):</strong></label>
                            <select id="sustenance_select" name="sustenance_codes[]" multiple class="form-control" size="8" required>
                                <option value="99">Sin observaciones</option>
                                <option value="1">Falta examen de entrada</option>
                                <option value="2">Falta examen de salida</option>
                                <option value="3">Falta Taller</option>
                                <option value="4">No ingreso al curso</option>
                                <option value="5">No alcanzo la nota minima</option>
                                <option value="6">Copio</option>
                                <option value="7">Conducta inapropiada</option>
                                <option value="8">No respondio al llamado</option>
                                <option value="9">Realizo otra actividad </option>
                                <option value="10">Suplantación</option>
                                <option value="11">Otros</option>
                            </select>
                            <small class="form-text text-muted">Mantén presionado Ctrl para seleccionar múltiples opciones</small>
                        </div>

                        <!-- Comentario adicional -->
                        <div class="form-group">
                            <label for="sustenance_comment"><strong>Comentario (opcional):</strong></label>
                            <textarea id="sustenance_comment" name="comment" class="form-control" rows="4" placeholder="Ingresa un comentario detallado sobre la incidencia..."></textarea>
                        </div>

                        <!-- Campos ocultos para almacenar datos -->
                        <input type="hidden" id="sustenance_user_id" name="user_id">
                        <input type="hidden" id="sustenance_course_id" name="course_id">
                        <input type="hidden" id="sustenance_session_id" name="session_id">
                        <input type="hidden" id="sustenance_record_id" name="record_id">
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancelar</button>
                    <button type="button" class="btn btn-primary" id="saveSustenanceBtn">Guardar Incidencia</button>
                </div>
            </div>
        </div>
    </div>

    {% set libro_reclamaciones_enabled = 'proikos'|api_get_plugin_setting('enable_libro_reclamaciones') %}
    {% set libro_reclamaciones_url = 'proikos'|api_get_plugin_setting('libro_reclamaciones_url') %}
    {% if libro_reclamaciones_enabled == 'true' and libro_reclamaciones_url %}
    <a href="{{ libro_reclamaciones_url }}" target="_blank" rel="noopener"
       id="libro-reclamaciones-btn"
       class="{{ _u.logged ? 'lr-logged' : 'lr-login' }}"
       title="Libro de Reclamaciones">
        <img src="{{ _p.web_plugin }}proikos/images/libro_reclamaciones.png" alt="Libro de Reclamaciones" class="lr-icon">
        <span class="lr-label">Libro de<br>Reclamaciones</span>
    </a>
    <style>
        #libro-reclamaciones-btn {
            position: fixed;
            z-index: 100000;
            display: flex;
            align-items: center;
            gap: 8px;
            background: #1565c0;
            color: #fff;
            text-decoration: none;
            border-radius: 50px;
            padding: 10px 16px 10px 12px;
            box-shadow: 0 3px 10px rgba(0,0,0,.35);
            font-size: 11px;
            font-weight: 700;
            line-height: 1.2;
            transition: transform .2s ease, box-shadow .2s ease;
        }
        #libro-reclamaciones-btn:hover,
        #libro-reclamaciones-btn:focus {
            color: #fff;
            transform: scale(1.06);
            box-shadow: 0 5px 16px rgba(0,0,0,.45);
            text-decoration: none;
        }
        #libro-reclamaciones-btn.lr-login {
            right: 20px;
            bottom: 20px;
        }
        #libro-reclamaciones-btn.lr-logged {
            right: 20px;
            bottom: 80px;
        }
        #libro-reclamaciones-btn .lr-icon {
            width: 36px;
            height: auto;
        }
        #libro-reclamaciones-btn .lr-label {
            text-transform: uppercase;
            letter-spacing: .3px;
        }
        @media (max-width: 767px) {
            #libro-reclamaciones-btn .lr-label {
                display: none;
            }
            #libro-reclamaciones-btn {
                padding: 12px;
                border-radius: 50%;
            }
        }
    </style>
    {% endif %}

</body>
</html>
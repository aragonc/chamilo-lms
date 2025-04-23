<!DOCTYPE html>
<html>
<head>
    <title>{{ _s.institution }}</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    {% if include_ldjson %}
    <script type="application/ld+json">
        {
          "@context":       "http://schema.org",
          "@type":          "EmailMessage",
          "description":    "Chamilo Mail Notification",
          "potentialAction": {
            "@type": "ViewAction",
            "target": "{{ link }}"
          }
        }
    </script>
    {% endif %}
</head>
<body style="background-color: #f6f6f6; font-family: sans-serif; -webkit-font-smoothing: antialiased; font-size: 14px; line-height: 1.4; margin: 0; padding: 2rem; -ms-text-size-adjust: 100%; -webkit-text-size-adjust: 100%;">
<table style="border-collapse: separate; mso-table-lspace: 0; mso-table-rspace: 0; width: 100%; background-color: #f6f6f6;">
    <tr>
        <td style="font-family: sans-serif; font-size: 14px; vertical-align: top; display: block; margin: 0 auto;">
            <div class="content" style="box-sizing: border-box; display: block; margin: 0 auto; max-width: 580px; padding: 10px;">
                <table class="main" style="border-collapse: separate; width: 100%; background: #ffffff; border-radius: 20px;">
                    <!-- START MAIN CONTENT AREA -->
                    <tr>
                        <td class="wrapper" style="font-family: sans-serif; font-size: 14px; vertical-align: top; box-sizing: border-box; padding: 10px;">

                            <!-- START HEADER LOGO -->
                            {% include 'mail/header.tpl'|get_template %}
                            <!-- END HEADER LOGO -->
                            <div {{ mail_content_style }}>
                                {{ content }}
                            </div>

                        </td>
                    </tr>
                    <!-- END MAIN CONTENT AREA -->
                </table>
                <!-- START FOOTER -->
                {% include 'mail/footer.tpl'|get_template %}
                <!-- END FOOTER -->
            </div>
        </td>
    </tr>
</table>
</body>
</html>

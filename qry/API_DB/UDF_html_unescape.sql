CREATE
OR REPLACE PYTHON3 SCALAR SCRIPT PBB.html_unescape(input_value VARCHAR(2000)) RETURNS VARCHAR(2000) AS import html def run(ctx): RETURN html.unescape(ctx.input_value) /
/**
 * CodeVault — CodeMirror Editor Initialization
 * External script to satisfy strict Content Security Policy (script-src 'self')
 */
document.addEventListener('DOMContentLoaded', () => {
    const codeArea = document.getElementById('code');
    const langSelect = document.getElementById('language');

    if (!codeArea) {
        return;
    }

    const modeMap = {
        'Java': 'text/x-java',
        'C': 'text/x-csrc',
        'C++': 'text/x-c++src',
        'C#': 'text/x-csharp',
        'Python': 'text/x-python',
        'JavaScript': 'text/javascript',
        'TypeScript': 'text/typescript',
        'MySQL': 'text/x-sql',
        'SQL': 'text/x-sql',
        'HTML': 'text/html',
        'XML': 'application/xml',
        'CSS': 'text/css',
        'JSP': 'application/x-jsp'
    };

    const initialLang = langSelect ? langSelect.value : 'Java';
    const initialMode = modeMap[initialLang] || 'text/x-java';

    const editor = CodeMirror.fromTextArea(codeArea, {
        lineNumbers: true,
        mode: initialMode,
        theme: 'dracula',
        autoCloseBrackets: true,
        matchBrackets: true,
        styleActiveLine: true,
        tabSize: 4,
        indentUnit: 4,
        lineWrapping: true
    });

    if (langSelect) {
        langSelect.addEventListener('change', () => {
            const mode = modeMap[langSelect.value] || 'text/plain';
            editor.setOption('mode', mode);
        });
    }

    const addForm = document.getElementById('addSnippetForm');
    if (addForm) {
        addForm.addEventListener('submit', () => {
            editor.save();
        });
    }

    const editForm = document.getElementById('editSnippetForm');
    if (editForm) {
        editForm.addEventListener('submit', () => {
            editor.save();
        });
    }
});

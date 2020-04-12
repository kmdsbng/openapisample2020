// dredd hooks document https://dredd.org/en/latest/hooks/index.html#hooks

const hooks = require('hooks');

hooks.beforeEachValidation(function (transaction) {
  // hooks.log(transaction.real);
  transaction.real.headers['content-type'] = 'application/json';
});



import React from 'react';
import { Field, reduxForm } from 'redux-form';
import styled from 'styled-components';

import DatePicker from '../components/control/datepicker/DatePicker';

const Caption = styled.p`
  font-weight: bold;
  margin-top: 10px;
`;

const ExampleForm = () => (
  <div>
    <form>
      <Caption>日付の選択</Caption>
      <Field name="sampledate" component={DatePicker} />
    </form>
  </div>
);

export default reduxForm({ form: 'datePickerExampleForm' })(ExampleForm);

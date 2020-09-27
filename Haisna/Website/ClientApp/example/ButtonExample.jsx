import React from 'react';
import { reduxForm } from 'redux-form';
import styled from 'styled-components';

import Button from '../components/control/Button';
import GuideButton from '../components/GuideButton';

const Caption = styled.p`
  font-weight: bold;
  margin-top: 10px;
`;

const ExampleForm = () => (
  <div>
    <form
      onSubmit={(event) => {
        event.preventDefault();
        // eslint-disable-next-line
        alert('ボタン２が押されました');
      }}
    >
      <Caption>ボタン</Caption>
      <Button
        onClick={() => {
          // eslint-disable-next-line
          alert('ボタン１が押されました');
        }}
        value="ボタン１"
      />
      <Caption>サブミットボタン</Caption>
      <Button type="submit" value="ボタン２" />
      <Caption>ガイドボタン</Caption>
      <GuideButton
        onClick={() => {
          // eslint-disable-next-line
          alert('ガイドボタンが押されました');
        }}
      />
    </form>
  </div>
);

export default reduxForm({ form: 'buttonExampleForm' })(ExampleForm);

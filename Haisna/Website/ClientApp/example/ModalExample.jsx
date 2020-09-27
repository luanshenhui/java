import React from 'react';
import PropTypes from 'prop-types';
import { reduxForm } from 'redux-form';
import styled from 'styled-components';

import Button from '../components/control/Button';
import GuideBase from '../components/common/GuideBase';

const Caption = styled.p`
  font-weight: bold;
  margin-top: 10px;
`;

// ガイド内部のスタイル定義
const Content = styled.div`
  width: 500px;
  height: 700px;
`;

const ModalWindow = ({ show, onOk, onClose }) => (
  <GuideBase visible={show} title="サンプルガイド" onClose={onClose} usePagination={false}>
    <Content>
      <p>ここには独自実装されたコンテンツが表示されます。</p>
    </Content>
    <div>
      <Button onClick={onOk} value="OK" />
      <Button onClick={onClose} value="キャンセル" />
    </div>
  </GuideBase>
);

// propTypesの定義
ModalWindow.propTypes = {
  show: PropTypes.bool.isRequired,
  onOk: PropTypes.func.isRequired,
  onClose: PropTypes.func.isRequired,
};

class ExampleForm extends React.Component {
  constructor(props) {
    super(props);
    // このサンプルではsetStateで状態管理をしているが、実際はReduxのStoreで管理しなければならない
    this.state = { visible: false };
  }

  render() {
    return (
      <div>
        <form>
          <Caption>ガイドサンプル</Caption>
          <Button
            value="OPEN"
            onClick={() => {
              this.setState({ visible: true });
            }}
          />
        </form>
        <ModalWindow
          show={this.state.visible}
          onOk={() => {
            this.setState({ visible: false });
          }}
          onClose={() => {
            this.setState({ visible: false });
          }}
        />
      </div>
    );
  }
}

export default reduxForm({ form: 'modalExampleForm' })(ExampleForm);

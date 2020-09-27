import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { getFormValues, reduxForm } from 'redux-form';

import Button from '../../components/control/Button';

import SecondLineDivGuide from '../../containers/common/SecondLineDivGuide';
import { openSecondLineDivGuide } from '../../modules/preference/secondLineDivModule';

class SecondLineDivGuideExampleForm extends React.Component {
  constructor(props) {
    super(props);
    // このサンプルではsetStateで状態管理をしているが、実際はReduxのStoreで管理しなければならない
    this.state = {
      selectedItem: null,
    };
  }

  render() {
    const { onOpenSecondLineDivGuide } = this.props;
    return (
      <form>
        <SecondLineDivGuide
          onSelected={(selectedItem) => {
            this.setState({ selectedItem });
          }}
        />
        <Button
          value="OPEN"
          onClick={() => {
            onOpenSecondLineDivGuide();
          }}
        />
        <div>{this.state.selectedItem && JSON.stringify(this.state.selectedItem)}</div>
      </form>
    );
  }
}

// propTypesの定義
SecondLineDivGuideExampleForm.propTypes = {
  onOpenSecondLineDivGuide: PropTypes.func.isRequired,
};

const form = 'rslCmtGuideExampleForm';

export default connect((state) => {
  const formValues = getFormValues(form)(state);
  return {
    formValues,
  };
}, (dispatch) => ({
  onOpenSecondLineDivGuide: () => {
    // 開くアクションを呼び出す
    dispatch(openSecondLineDivGuide());
  },
}))(reduxForm({ form })(SecondLineDivGuideExampleForm));

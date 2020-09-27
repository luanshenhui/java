import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { getFormValues, reduxForm } from 'redux-form';

import Button from '../../components/control/Button';

import RslCmtGuide from '../../containers/common/RslCmtGuide';
import { openRslCmtGuide } from '../../modules/preference/rslCmtModule';

class RslCmtGuideExampleForm extends React.Component {
  constructor(props) {
    super(props);
    // このサンプルではsetStateで状態管理をしているが、実際はReduxのStoreで管理しなければならない
    this.state = {
      selectedItem: null,
    };
  }

  render() {
    const { onOpenRslCmtGuide } = this.props;
    return (
      <form>
        <RslCmtGuide
          onSelected={(selectedItem) => {
            this.setState({ selectedItem });
          }}
        />
        <Button
          value="OPEN"
          onClick={() => {
            onOpenRslCmtGuide();
          }}
        />
        <div>{this.state.selectedItem && JSON.stringify(this.state.selectedItem)}</div>
      </form>
    );
  }
}

// propTypesの定義
RslCmtGuideExampleForm.propTypes = {
  onOpenRslCmtGuide: PropTypes.func.isRequired,
};

const form = 'rslCmtGuideExampleForm';

export default connect((state) => {
  const formValues = getFormValues(form)(state);
  return {
    formValues,
  };
}, (dispatch) => ({
  onOpenRslCmtGuide: () => {
    // 開くアクションを呼び出す
    dispatch(openRslCmtGuide());
  },
}))(reduxForm({ form })(RslCmtGuideExampleForm));

import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { getFormValues, reduxForm } from 'redux-form';

import Button from '../../components/control/Button';

import UserGuide from '../../containers/common/UserGuide';
import { openUserGuide } from '../../modules/preference/hainsUserModule';

class UserGuideExampleForm extends React.Component {
  constructor(props) {
    super(props);
    // このサンプルではsetStateで状態管理をしているが、実際はReduxのStoreで管理しなければならない
    this.state = {
      selectedItem: null,
    };
  }

  render() {
    const { onOpenUserGuide } = this.props;
    return (
      <form>
        <UserGuide
          onSelected={(selectedItem) => {
            this.setState({ selectedItem });
          }}
        />
        <Button
          value="OPEN"
          onClick={() => {
            onOpenUserGuide();
          }}
        />
        <div>{this.state.selectedItem && JSON.stringify(this.state.selectedItem)}</div>
      </form>
    );
  }
}

// propTypesの定義
UserGuideExampleForm.propTypes = {
  onOpenUserGuide: PropTypes.func.isRequired,
};

const form = 'userGuideExampleForm';

export default connect((state) => {
  const formValues = getFormValues(form)(state);
  return {
    formValues,
  };
}, (dispatch) => ({
  onOpenUserGuide: () => {
    // 開くアクションを呼び出す
    dispatch(openUserGuide());
  },
}))(reduxForm({ form })(UserGuideExampleForm));

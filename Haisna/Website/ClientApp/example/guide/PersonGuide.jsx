import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { getFormValues, reduxForm } from 'redux-form';

import Button from '../../components/control/Button';

import PersonGuide from '../../containers/common/PersonGuide';
import { openPersonGuide } from '../../modules/preference/personModule';

class PersonGuideExampleForm extends React.Component {
  constructor(props) {
    super(props);
    // このサンプルではsetStateで状態管理をしているが、実際はReduxのStoreで管理しなければならない
    this.state = {
      selectedItem: null,
    };
  }

  render() {
    const { onOpenPersonGuide } = this.props;
    return (
      <form>
        <PersonGuide
          onSelected={(selectedItem) => {
            this.setState({ selectedItem });
          }}
        />
        <Button
          value="OPEN"
          onClick={() => {
            onOpenPersonGuide();
          }}
        />
        <div>{this.state.selectedItem && JSON.stringify(this.state.selectedItem)}</div>
      </form>
    );
  }
}

// propTypesの定義
PersonGuideExampleForm.propTypes = {
  onOpenPersonGuide: PropTypes.func.isRequired,
};

const form = 'personGuideExampleForm';

export default connect((state) => {
  const formValues = getFormValues(form)(state);
  return {
    formValues,
  };
}, (dispatch) => ({
  onOpenPersonGuide: () => {
    // 開くアクションを呼び出す
    dispatch(openPersonGuide());
  },
}))(reduxForm({ form })(PersonGuideExampleForm));

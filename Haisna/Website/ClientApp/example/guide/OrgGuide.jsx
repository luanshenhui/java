import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { getFormValues, reduxForm } from 'redux-form';

import Chip from '../../components/Chip';
import { FieldSet } from '../../components/Field';
import GuideButton from '../../components/GuideButton';

import OrgGuide from '../../containers/common/OrgGuide';
import { openOrgGuide } from '../../modules/preference/organizationModule';

class OrgGuideExampleForm extends React.Component {
  constructor(props) {
    super(props);
    // このサンプルではsetStateで状態管理をしているが、実際はReduxのStoreで管理しなければならない
    this.state = {
      selectedItem: null,
    };
  }

  render() {
    const { onOpenOrgGuide } = this.props;
    return (
      <form>
        <FieldSet>
          <OrgGuide
            onSelected={(selectedItem) => {
              this.setState({ selectedItem });
            }}
          />
          <GuideButton
            onClick={() => {
              onOpenOrgGuide();
            }}
          />
          {this.state.selectedItem && (
            <Chip
              label={this.state.selectedItem.org.orgname}
              onDelete={() => {
                const selectedItem = null;
                this.setState({ selectedItem });
              }}
            />
          )}
        </FieldSet>
      </form>
    );
  }
}

// propTypesの定義
OrgGuideExampleForm.propTypes = {
  onOpenOrgGuide: PropTypes.func.isRequired,
};

const form = 'orgGuideExampleForm';

export default connect((state) => {
  const formValues = getFormValues(form)(state);
  return {
    formValues,
  };
}, (dispatch) => ({
  onOpenOrgGuide: () => {
    // 開くアクションを呼び出す
    dispatch(openOrgGuide());
  },
}))(reduxForm({ form })(OrgGuideExampleForm));

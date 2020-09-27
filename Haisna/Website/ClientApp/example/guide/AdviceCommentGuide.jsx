import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { getFormValues, reduxForm } from 'redux-form';

import { FieldSet } from '../../components/Field';
import GuideButton from '../../components/GuideButton';

import AdviceCommentGuide from '../../containers/common/AdviceCommentGuide';
// import { openAdviceCommentGuide } from '../../modules/preference/judCmtStcModule';

class AdviceCommentGuideExampleForm extends React.Component {
  constructor(props) {
    super(props);
    // このサンプルではsetStateで状態管理をしているが、実際はReduxのStoreで管理しなければならない
    this.state = {
    };
  }

  render() {
    // const { onOpenAdviceCommentGuide } = this.props;
    return (
      <form>
        <FieldSet>
          <AdviceCommentGuide
            onSelected={() => {
            }}
          />
          <GuideButton
            onClick={() => {
            }}
          />
        </FieldSet>
      </form>
    );
  }
}

// propTypesの定義
// AdviceCommentGuideExampleForm.propTypes = {
//   onOpenAdviceCommentGuide: PropTypes.func.isRequired,
// };

// const form = 'adviceCommentGuideExampleForm';

// export default connect((state) => {
//   const formValues = getFormValues(form)(state);
//   return {
//     formValues,
//   };
// }, (dispatch) => ({
//   onOpenOrgGuide: () => {
//     // 開くアクションを呼び出す
//     dispatch(openAdviceCommentGuide());
//   },
// }))(reduxForm({ form })(AdviceCommentGuideExampleForm));

export default AdviceCommentGuideExampleForm;
